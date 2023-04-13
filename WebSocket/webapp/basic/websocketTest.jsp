<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<title>Insert title here</title>
</head>
<body>
    <!-- 메시지 표시 영역 -->
    <textarea id="messageTextArea" readonly="readonly" rows="10" cols="45"></textarea><br>

    <!-- 송신 메시지 텍스트박스 -->
	<!-- 처음 보내는 메시지는 사용자 이름을 입력하여 보낸다.  -->
	<div>처음 보내는 메시지는 사용자 이름을 입력하여 보내세요..</div>
    <input type="text" id="messageText" size="50">

    <!-- 송신 버튼 -->
    <input type="button" value="Send" onclick="sendMessage()">

    <script type="text/javascript">
        //웹소켓 초기화 (웹소켓 URI 주소 : ws://서버주소:포트번호/컨텍스트이름(프로젝트명)/웹소켓서비스명
		// 포트번호 80번은 생략 가능
// 		const webSocket = new WebSocket("ws://localhost/webSocketTest/basicsocket");
        const contextPath = "<%=request.getContextPath()%>";
        const webSocket = new WebSocket("ws://localhost" + contextPath +"/basicsocket");
        
        const messageTextArea = document.getElementById("messageTextArea");
        
        //메시지가 오면 messageTextArea요소에 메시지를 추가한다.
        webSocket.onmessage = function processMessge(message){
            //JSON 풀기
            let jsonData = JSON.parse(message.data);
            if(jsonData.message != null) {
                messageTextArea.value += jsonData.message + "\n"
            };
        }
        
        //메시지 보내기
        function sendMessage(){
            const messageText = document.getElementById("messageText");
            webSocket.send(messageText.value);
            messageText.value = "";
        }
    </script>
</body>
</html>