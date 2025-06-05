package board.service;

import java.util.List;

/**
 * @ClassName : BoardService.java
 * @Description : 게시판 서비스 인터페이스
 * @ModificationInformation
 *
 *                          수정일 수정자 수정내용 ---------- ---------
 *                          ------------------------------- 2009.03.16 개발팀 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009.03.16
 * @version 1.0
 * @see
 * 
 *      Copyright (C) by MOPAS All right reserved.
 */
public interface BoardService {

	/**
	 * 글을 등록한다.
	 * 
	 * @param vo 등록할 정보가 담긴 BoardVO
	 * @return 등록된 글의 ID 또는 결과 문자열
	 * @throws Exception
	 */
	String insertBoard(BoardVO vo) throws Exception;

	/**
	 * 글을 수정한다.
	 * 
	 * @param vo 수정할 정보가 담긴 BoardVO
	 * @throws Exception
	 */
	void updateBoard(BoardVO vo) throws Exception;

	/**
	 * 글을 삭제한다.
	 * 
	 * @param vo 삭제할 정보가 담긴 BoardVO
	 * @throws Exception
	 */
	void deleteBoard(BoardVO vo) throws Exception;

	/**
	 * 글을 조회한다.
	 * 
	 * @param vo 조회할 정보가 담긴 BoardVO
	 * @return 조회한 글
	 * @throws Exception
	 */
	BoardVO selectBoard(BoardVO vo) throws Exception;

	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param boardVO 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @throws Exception
	 */
	List<?> selectBoardList(BoardVO boardVO) throws Exception;

	/**
	 * 글 총 갯수를 조회한다.
	 * 
	 * @param boardVO 조회할 정보가 담긴 VO
	 * @return 글 총 개수
	 * @throws Exception
	 */
	int selectBoardListTotCnt(BoardVO boardVO) throws Exception;

	BoardVO selectLoginCheck(BoardVO vo);

	void insertReply(BoardVO vo) throws Exception;

	List<BoardVO> selectReplyList(BoardVO vo) throws Exception;

	void updateBoardCount(BoardVO vo) throws Exception;
}
