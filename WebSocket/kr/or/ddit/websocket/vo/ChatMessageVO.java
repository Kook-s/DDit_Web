package kr.or.ddit.websocket.vo;

import java.io.Serializable;

public class ChatMessageVO  implements Serializable{
	private static final long serialVersionUID = 1L;
	
	private String command;
	private String room;
	private String message;
	
	public ChatMessageVO() {	}

	public ChatMessageVO(String command, String room, String message) {
		super();
		this.command = command;
		this.room = room;
		this.message = message;
	}

	public String getCommand() {
		return command;
	}

	public void setCommand(String command) {
		this.command = command;
	}

	public String getRoom() {
		return room;
	}

	public void setRoom(String room) {
		this.room = room;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	@Override
	public String toString() {
		return "ChatMessageVO [command=" + command + ", room=" + room + ", message=" + message + "]";
	}
	
}
