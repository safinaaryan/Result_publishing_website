// =========================================================================
// 1. PAGE NAVIGATION UTILITY
// =========================================================================
function showPage(id) {
  const pages = document.querySelectorAll('.page');
  const next  = document.getElementById(id);

  const current = document.querySelector('.page.active');
  if (current && current !== next) {
    current.classList.add('exit');
    current.addEventListener('animationend', () => {
      current.classList.remove('active', 'exit');
    }, { once: true });
  }

  next.classList.add('active', 'enter');
  next.addEventListener('animationend', () => {
    next.classList.remove('enter');
  }, { once: true });
}

// =========================================================================
// 2. PASSWORD MATCH RE-CHECKERS (LIVE LOOKUPS)
// =========================================================================

// Student Password Inputs Listener
document.getElementById('password').addEventListener('input', checkStudentPasswordMatch);
document.getElementById('confirm-password').addEventListener('input', checkStudentPasswordMatch);

function checkStudentPasswordMatch() {
  const pw  = document.getElementById('password').value;
  const cpw = document.getElementById('confirm-password').value;
  const hint = document.getElementById('pw-match-hint');

  if (!cpw) { hint.textContent = ''; return; }

  if (pw === cpw) {
    hint.textContent = '✓ Passwords match';
    hint.style.color = 'var(--green)';
    document.getElementById('confirm-password').style.borderColor = '';
  } else {
    hint.textContent = '✗ Passwords do not match';
    hint.style.color = 'var(--red)';
    document.getElementById('confirm-password').style.borderColor = 'var(--red)';
  }
}

// Teacher Password Inputs Listener
document.getElementById('teacher-password').addEventListener('input', checkTeacherPasswordMatch);
document.getElementById('teacher-confirm-password').addEventListener('input', checkTeacherPasswordMatch);

function checkTeacherPasswordMatch() {
  const pw = document.getElementById('teacher-password').value;
  const cpw = document.getElementById('teacher-confirm-password').value;
  const hint = document.getElementById('teacher-pw-match-hint');

  if (!cpw) { hint.textContent = ''; return; }

  if (pw === cpw) {
    hint.textContent = '✓ Passwords match';
    hint.style.color = 'var(--green)';
    document.getElementById('teacher-confirm-password').style.borderColor = '';
  } else {
    hint.textContent = '✗ Passwords do not match';
    hint.style.color = 'var(--red)';
    document.getElementById('teacher-confirm-password').style.borderColor = 'var(--red)';
  }
}

// =========================================================================
// 3. STUDENT LOGIN & REPORT RENDERING
// =========================================================================
function handleLogin() {
  const errorEl = document.getElementById('login-error');
  errorEl.style.display = 'none';

  const studentId = document.getElementById('student-id').value.trim();
  const password  = document.getElementById('password').value;
  const confirmPw = document.getElementById('confirm-password').value;
  const btn       = document.getElementById('login-btn');

  if (!studentId || !password || !confirmPw) {
    errorEl.textContent = 'All fields are required.';
    errorEl.style.display = 'block';
    return;
  }
  if (password !== confirmPw) {
    errorEl.textContent = 'Passwords do not match. Please re-enter.';
    errorEl.style.display = 'block';
    return;
  }

  btn.disabled = true;

  const formData = new FormData();
  formData.append('student_id', studentId);
  formData.append('password', password);
  formData.append('confirm_password', confirmPw);

  fetch('login.php', { method: 'POST', body: formData })
    .then(res => res.json())
    .then(data => {
      btn.disabled = false;
      if (!data.success) {
        errorEl.textContent = data.message;
        errorEl.style.display = 'block';
        return;
      }
      renderStudentResult(data);
      showPage('page-result');
    })
    .catch(() => {
      btn.disabled = false;
      errorEl.textContent = 'An error occurred while connecting to the server.';
      errorEl.style.display = 'block';
    });
}

function renderStudentResult(d) {
  const container = document.getElementById('page-result');
  
  let rows = '';
  // 1. Create a variable to track overall status on the frontend
  let frontendOverallPass = true; 
  
  d.results.forEach(r => {
    // 2. Check if this specific subject is passed
    const isPass = parseInt(r.marks_obtained) >= parseInt(r.pass_marks);
    
    // 3. If the student fails even ONE subject, flip the overall status to false
    if (!isPass) {
      frontendOverallPass = false;
    }

    const statusText = isPass ? 'PASS' : 'FAIL';
    const statusClass = isPass ? 'badge pass' : 'badge fail';

    rows += `
      <tr>
        <td><strong>${r.subject_name}</strong></td>
        <td><code class="code-box">${r.subject_code}</code></td>
        <td>${r.full_marks}</td>
        <td>${r.pass_marks}</td>
        <td><strong>${r.marks_obtained}</strong></td>
        <td><span class="grade-box">${r.grade}</span></td>
        <td><span class="${statusClass}">${statusText}</span></td>
      </tr>
    `;
  });

  // Edge case: If there are no subjects recorded at all, don't show as passed
  if (d.results.length === 0) frontendOverallPass = false;

  // 4. FIX: Use our newly calculated variable instead of relying on the backend
  const overallClass = frontendOverallPass ? 'status-banner pass' : 'status-banner fail';
  const overallText  = frontendOverallPass ? 'PASSED' : 'FAILED';

  container.innerHTML = `
    <div class="card animate-fade">
      <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:1rem;">
        <div>
          <h1 class="card-title" style="margin-bottom:0.25rem">${d.student.name}</h1>
          <p class="card-subtitle">Student ID: <strong>${d.student.id}</strong></p>
        </div>
        <div class="${overallClass}">PROMOTIONAL STATUS: ${overallText}</div>
      </div>

      <div class="summary-grid" style="margin-top:1.5rem">
        <div class="summary-item"><div class="summary-val">${d.total_obtained} / ${d.total_full}</div><div class="summary-key">Total Marks</div></div>
        <div class="summary-item"><div class="summary-val">${d.percentage}%</div><div class="summary-key">Percentage</div></div>
        <div class="summary-item"><div class="summary-val">${d.overall_grade}</div><div class="summary-key">Final Grade</div></div>
      </div>

      <div class="progress-wrap" style="margin-top:1.25rem">
        <div class="progress-bar" id="prog-bar"></div>
      </div>
      <p class="progress-label">${d.percentage}% scored</p>

      <div class="table-wrap" style="margin-top:1.25rem">
        <table>
          <thead>
            <tr>
              <th>Subject</th><th>Code</th><th>Full Marks</th><th>Pass Marks</th><th>Obtained</th><th>Grade</th><th>Status</th>
            </tr>
          </thead>
          <tbody>${rows}</tbody>
        </table>
      </div>

      <div style="text-align:right;margin-top:1.5rem">
        <button class="btn-logout" onclick="logoutAll()">← Back to Login</button>
      </div>
    </div>`;

  setTimeout(() => {
    const bar = document.getElementById('prog-bar');
    if (bar) bar.style.width = d.percentage + '%';
  }, 100);
}

// =========================================================================
// 4. TEACHER DASHBOARD LOGIC
// =========================================================================
function handleTeacherLogin() {
  const errorEl = document.getElementById('teacher-login-error');
  errorEl.style.display = 'none';

  const teacherId = document.getElementById('teacher-id').value.trim();
  const password = document.getElementById('teacher-password').value;
  const confirmPw = document.getElementById('teacher-confirm-password').value;
  const btn = document.getElementById('teacher-login-btn');

  if (!teacherId || !password || !confirmPw) {
    errorEl.textContent = 'All login fields are required.';
    errorEl.style.display = 'block';
    return;
  }
  if (password !== confirmPw) {
    errorEl.textContent = 'Passwords must match.';
    errorEl.style.display = 'block';
    return;
  }

  btn.disabled = true;

  const formData = new FormData();
  formData.append('teacher_id', teacherId);
  formData.append('password', password);
  formData.append('confirm_password', confirmPw);

  fetch('teacher_login.php', { method: 'POST', body: formData })
    .then(res => res.json())
    .then(data => {
      btn.disabled = false;
      if (!data.success) {
        errorEl.textContent = data.message;
        errorEl.style.display = 'block';
        return;
      }
      document.getElementById('teacher-welcome').textContent = `Welcome, ${data.teacher.name}`;
      showPage('page-teacher');
    })
    .catch(() => {
      btn.disabled = false;
      errorEl.textContent = 'Connection error with teacher validation backend.';
      errorEl.style.display = 'block';
    });
}

function handleMarksSubmission(e) {
  e.preventDefault();
  const errorEl = document.getElementById('marks-error');
  const successEl = document.getElementById('marks-success');
  
  errorEl.style.display = 'none';
  successEl.style.display = 'none';

  const btn = document.getElementById('submit-marks-btn');
  btn.disabled = true;

  const formData = new FormData();
  formData.append('student_id', document.getElementById('input-student-id').value.trim());
  // NEW: Grab the name and class
  formData.append('student_name', document.getElementById('input-student-name').value.trim());
  formData.append('student_class', document.getElementById('input-student-class').value.trim());
  
  formData.append('subject_code', document.getElementById('input-subject-code').value.trim());
  formData.append('marks_obtained', document.getElementById('input-marks').value.trim());
  formData.append('grade', document.getElementById('input-grade').value.trim());
  formData.append('exam_year', document.getElementById('input-year').value.trim());

  fetch('submit_marks.php', { method: 'POST', body: formData })
    .then(res => res.json())
    .then(data => {
      btn.disabled = false;
      if (!data.success) {
        errorEl.textContent = data.message;
        errorEl.style.display = 'block';
        return;
      }
      successEl.textContent = 'Success! Marks saved directly to database.';
      successEl.style.display = 'block';
      
      document.getElementById('marks-form').reset();
      document.getElementById('input-year').value = '2026';
    })
    .catch(() => {
      btn.disabled = false;
      errorEl.textContent = 'Server processing error. Could not commit transaction.';
      errorEl.style.display = 'block';
    });
}

// =========================================================================
// 5. GLOBAL LOGOUT / VIEW RESET
// =========================================================================
function logoutAll() {
  const fields = [
    'student-id','password','confirm-password',
    'teacher-id','teacher-password','teacher-confirm-password'
  ];
  fields.forEach(id => {
    const el = document.getElementById(id);
    if(el) el.value = '';
  });
  
  document.getElementById('pw-match-hint').textContent = '';
  document.getElementById('teacher-pw-match-hint').textContent = '';
  
  document.getElementById('login-error').style.display = 'none';
  document.getElementById('teacher-login-error').style.display = 'none';
  document.getElementById('marks-error').style.display = 'none';
  document.getElementById('marks-success').style.display = 'none';

  showPage('page-login');
}