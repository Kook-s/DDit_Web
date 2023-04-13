package kr.or.ddit.websocket.vo;

import javax.websocket.Session;

public class DditChatVO {
	private String name;
	private Session session;
	
	public DditChatVO(String name, Session session) {
		super();
		this.name = name;
		this.session = session;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Session getSession() {
		return session;
	}

	public void setSession(Session session) {
		this.session = session;
	}
	
	
}
