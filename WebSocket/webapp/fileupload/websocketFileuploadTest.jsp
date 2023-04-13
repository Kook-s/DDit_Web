<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<title>File Upload Client</title>
    <script type="text/javascript">
        let ws = null;    
        function connector(){
        	// 웹소켓 초기화
        	const contextPath = "<%=request.getContextPath()%>";
            const url = "ws://localhost" + contextPath +"/upload"; 
            ws = new WebSocket(url);
            
            ws.binaryType="arraybuffer"; // 전송할 binary데이터의 종류 설정
            ws.onopen=function(){
                alert("연결 완료");
            };            
            ws.onmessage = function(e){
                alert(e.msg);
            };
            ws.onclose = function() {
                alert("연결 종료");
            };
            ws.onerror = function(e) {
                alert(e.msg);
            }
        }    
        
        function sendFile(){
            const file = document.getElementById('file').files[0];
            ws.send('filename:'+file.name);  // 파일 이름을 문자열로 전송
            //alert('test');
            
            const reader = new FileReader();
            let rawData = new ArrayBuffer();            

            reader.loadend = function() { }
            
            reader.onload = function(e) {
                rawData = e.target.result;
                ws.send(rawData);		// 파일 내용 데이터 전송
                alert("파일 전송이 완료 되었습니다.")
                ws.send('end');			// 'end' 문자열 전송
            }
            reader.readAsArrayBuffer(file);
        }
				
				// 이벤트 설정
        function addEvent(){
            document.getElementById("connect").addEventListener("click", connector, false);
            document.getElementById("send").addEventListener("click", sendFile, false);
        }
        window.addEventListener("load", addEvent, false);
    </script>
</head>
<body>
	<input id="file" type="file" >
    <input id="connect" type="button" value="connect">
    <input id="send" type="button" value="send">
</body>
</html>