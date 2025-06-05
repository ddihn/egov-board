package board.service;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class BoardVO {
	private String idx;
	private String title;
	private String contents;
	private String count;
	private String writer;
	private String writerNm;
	private String indate;

	private String seq;
	private String reply;

	private String filename;

	private String userId;
	private String password;

	private String userName;

	private String searchKeyword;

	private int pageUnit;
	private int pageSize;
	private int pageIndex;
	private int firstIndex;
	private int lastIndex;
	private int recordCountPerPage;
}
