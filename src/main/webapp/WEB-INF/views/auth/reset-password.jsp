<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>비밀번호 초기화 - 관리자</title>
    <style>
        .message {
            padding: 8px;
            margin-bottom: 10px;
            border-radius: 4px;
        }
        .success {
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
        }
        .error {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
<form id="resetPasswordForm" method="post">
    <div>
        <label for="username">사용자 ID: </label>
        <input type="text" id="username" name="username" required>
    </div>
    <div>
        <button type="submit">비밀번호 초기화</button>
    </div>
</form>
<div id="message" class="hidden"></div>

<script>
    const form = document.getElementById('resetPasswordForm');
    const messageDiv = document.getElementById('message');

    form.addEventListener('submit', function (event){
        event.preventDefault();

        const username = document.getElementById('username').value.trim();

        if(!username){
            showMessage("사용자 ID를 입력해주세요.", "error");
            return;
        }

        fetch(`/api/admin/reset-password?username=${encodeURIComponent(username)}`, {
            method: 'POST'
        })
            .then(response => {
                if(!response.ok){
                    return response.text().then(text => { throw new Error(text); });
                }
                return response.text();
            })
            .then(data => {
                showMessage(data, "success");
            })
            .catch(error => {
                showMessage(error.message, "error");
            });
    });
    function showMessage(text, type) {
        messageDiv.textContent = text;
        messageDiv.className = `message ${type}`;
        messageDiv.classList.remove('hidden');
    }
</script>
</body>
</html>
