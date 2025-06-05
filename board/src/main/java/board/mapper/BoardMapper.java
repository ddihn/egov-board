package board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import board.service.BoardVO;

@Mapper
public interface BoardMapper {

	BoardVO selectBoard(BoardVO vo) throws Exception;

	List<BoardVO> selectBoardList() throws Exception;

	void insertBoard(BoardVO board) throws Exception;

	void updateBoard(BoardVO board) throws Exception;

	void deleteBoard(BoardVO vo) throws Exception;

	List<?> selectBoardList(BoardVO searchVO);

	int selectBoardListTotCnt(BoardVO searchVO);

	BoardVO selectLoginCheck(BoardVO searchVO);

	List<BoardVO> selectReplyList(BoardVO vo);

	void insertReply(BoardVO boardVO) throws Exception;

	void updateBoardCount(BoardVO vo) throws Exception;

}