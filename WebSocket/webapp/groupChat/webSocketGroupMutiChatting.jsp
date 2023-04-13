<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<title>Insert title here</title>
<style type="text/css">
	#chatArea {
 		display: none;	 
		border:2px solid blue;
		padding: 5px;   width : 430px;
		margin: 0px auto;
	}
	#connectArea {
		border:2px solid green;	padding: 5px; width : 430px;
		margin: 0px auto;
	}
	
	#messageTextArea{
		height:200px; width : 425px;
	}
	
	#chatRoom{
		display: none;
		border:2px solid red;	padding: 5px; width : 330px;
		margin: 0px auto;
	}
	
	#chatRoom select {
		width : 325px;
	}
	
	table{
		margin: 0px auto;
	}
	
</style>
</head>
<body>
<div id="">
	<table>
	<tr>
		<td style="vertical-align: top;">
			<div id="chatArea">
			    <!-- 메시지 표시 영역 -->
			    <textarea id="messageTextArea" readonly="readonly" ></textarea><br><br>
			    <!-- 송신 메시지 텍스트박스 -->
			    <input type="text" id="messageText" size="40"> <!-- onkeydown="sendMessage()" -->
			    <!-- 송신 버튼 -->
			    <input type="button" value="Send" onclick="sendMessage()">
			    <input type="button" value="접속종료" onclick="closing()">
		    </div>
		</td>
		<td>
			<div id="chatRoom">
				<input type="text" id="newRoomName"> <input type="button" value="채팅방만들기" onclick="createRoom()"><br><br>
		    	채팅방 목록<br>
		    	<select id="chatRoomList" size="10"></select><br>
		    	<input type="button" value="채팅방 입장" onclick="chatRoomIn()"><br><br>
		    	<span id="chatRoomName">전체</span> 채팅방 멤버 목록<br>
		    	<select id="chatRoomMemList" size="20"></select><br>
		    	<input type="button" value="채팅방 나가기" onclick="chatRoomOut()">
		    </div>
		</td>
	</tr>
	</table>
    <br>
    <div id="connectArea">
    	<!-- 접속자 입력 텍스트박스 -->
	    사용자ID : <input type="text" id="userId" size="20">
	    <!-- 접속 버튼 -->
	    <input type="button" value="접속하기" onclick="connectting()">
    </div>
</div>
<br><br><br><br><br><br><br><br><br>
<br><br><br><br><br><br><br><br><br>
    
<script type="text/javascript">
   	let webSocket = null; // 웹소켓 변수 선언
	const messageTextArea = document.getElementById("messageTextArea");
   	const messageText = document.getElementById("messageText");
   	const userText = document.getElementById("userId");
   	
   	function connectting(){
   		if(userText.value.trim()==""){
   			alert("접속자 ID를 입력하세요");
   			userText.focus();
   			return;
   		}
		//웹소켓 초기화
		const contextPath = "<%=request.getContextPath()%>";
		webSocket = new WebSocket("ws://localhost" + contextPath + "/websocktGroupMultiChat.do");
        
    	// 처음 접속 성공하면 
		webSocket.onopen = function onOpen(event){
			document.getElementById("connectArea").style.display = "none";
			
			document.getElementById("chatRoom").style.display = "block";
			document.getElementById("chatArea").style.display = "block";
			// webSocket.send(userText.value);
			webSocket.send( createMessage("connect", "전체", userText.value) );
			
		}
        
		//메시지가 오면 messageTextArea요소에 메시지를 추가한다.
		webSocket.onmessage = function processMessge(message){
			//Json 풀기
			var jsonData = JSON.parse(message.data);
			if(jsonData.message != null) {
					messageTextArea.value += jsonData.message + "\n"
					messageTextArea.scrollTop = 9999999;
			};
				
			// 채팅방 목록 출력하기
			if(jsonData.roomList != null){
				var jsonRoomList = JSON.parse(jsonData.roomList);
				var selElement = document.getElementById("chatRoomList");
				var strHtml = "";
				for(var i=0; i<jsonRoomList.length; i++){
					strHtml += "<option value='" + jsonRoomList[i] + "'>" + jsonRoomList[i] + "</option>";
				}
				selElement.innerHTML = strHtml;
			}
			
			if(jsonData.roomName != null){
				document.getElementById("chatRoomName").innerHTML = jsonData.roomName;
			}
           
			// 채팅방 멤버 목록 출력하기
			if(jsonData.roomMemList != null){
				var jsonRoomMemList = JSON.parse(jsonData.roomMemList);
				var selElement = document.getElementById("chatRoomMemList");
				var strHtml = "";
				for(var i=0; i<jsonRoomMemList.length; i++){
					strHtml += "<option value='" + jsonRoomMemList[i] + "'>" + jsonRoomMemList[i] + "</option>";
				}
				selElement.innerHTML = strHtml;
			}
		}
        
		webSocket.onerror = function showErrorMsg(event) {
			alert("오류 : " + event.data);
		}
		
		webSocket.onclose = function(event){
			messageTextArea.value = "";
			messageText.value = "";
			userText.value = "";
			document.getElementById("connectArea").style.display = "block";
			document.getElementById("chatRoom").style.display = "none";
			document.getElementById("chatArea").style.display = "none";
		}
   	}
   
   	// 메시지 구조  {"command" : "명령종류", "room" : "채팅방이름", "message" : "메시지" }
   	// 명령 종류 : "create" - 채팅방 만들기, "change" - 채팅방 이동, "message" - 메시지 전송, "connect" - 처음 접속 
   	
   	
	//메시지 보내기
	function sendMessage(){
		if(messageText.value.trim()==""){
			messageText.focus();
			return;
		}
		var room = document.getElementById("chatRoomName").innerHTML.trim();
		
		//webSocket.send('{"room" : "' + "전체" + '", "message" : "' + messageText.value + '"}' );
		webSocket.send( createMessage("message", room, messageText.value) );
		messageText.value = ""; 
	}
  	
   	// 채팅방 만들기
   	function createRoom(){
   		var newRoom = document.getElementById("newRoomName");
   		if(newRoom.value==""){
   			alert("생성할 채팅방을 입력한 후 사용하세요.")
   			newRoom.focus();
   			return;
   		}
   		webSocket.send( createMessage("create", newRoom.value, null) );
   		newRoom.value = ""; 
   	}
   	
   	// 채팅방 이동
   	function chatRoomIn(){
   		var selectRoom = document.getElementById("chatRoomList")
   		if(selectRoom.selectedIndex==-1 || selectRoom.value==""){
   			alert("이동할 채팅방을 선택한 후 사용하세요.");
   			return;
   		}
   		webSocket.send( createMessage("change", selectRoom.value, null) );
   	}
   	
   	// 채팅방 나가기  ==> 즉, '전체' 채팅방으로 이동
   	function chatRoomOut(){
   		webSocket.send( createMessage("change", "전체", null) );
   	}
   	
   	// 전송할 메시지를 작성하는 함수
   	function createMessage(command, room, message){
   		return '{"command" : "' + command + '", "room" : "' + room + '", "message" : "' + message + '"}'
   	}
       
	function closing(){
		webSocket.close();
	}
	
	window.onbeforeunload = function(){
		closing();
	}
</script>
</body>
</html>