package board.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import board.mapper.BoardMapper;
import board.service.BoardService;
import board.service.BoardVO;

@Service("boardService")
public class BoardServiceImpl implements BoardService {

	private static final Logger LOGGER = LoggerFactory.getLogger(BoardServiceImpl.class);

	/** MyBatis Mapper */
	@Resource(name = "boardMapper")
	private BoardMapper boardDAO;

	/**
	 * 글을 등록한다.
	 */
	@Override
	public String insertBoard(BoardVO vo) throws Exception {
		LOGGER.debug("insertBoard: {}", vo);

		// ID 생성 로직 (주석 해제 시 사용 가능)
		// String id = egovIdGnrService.getNextStringId();
		// vo.setIdx(id);

		boardDAO.insertBoard(vo);
		return vo.getIdx(); // idx가 문자열이어야 함 (long 타입이면 String으로 변환)
	}

	/**
	 * 글을 수정한다.
	 */
	@Override
	public void updateBoard(BoardVO vo) throws Exception {
		boardDAO.updateBoard(vo);
	}

	/**
	 * 글을 삭제한다.
	 */
	@Override
	public void deleteBoard(BoardVO vo) throws Exception {
		boardDAO.deleteBoard(vo);
	}

	/**
	 * 글을 조회한다.
	 */
	@Override
	public BoardVO selectBoard(BoardVO vo) throws Exception {
		BoardVO resultVO = boardDAO.selectBoard(vo);
		if (resultVO == null) {
			System.out.println("error in BoardServiceImpl");
		}
		return resultVO;
	}

	/**
	 * 글 목록을 조회한다.
	 */
	@Override
	public List<?> selectBoardList(BoardVO searchVO) throws Exception {
		return boardDAO.selectBoardList(searchVO);
	}

	/**
	 * 글 총 갯수를 조회한다.
	 */
	@Override
	public int selectBoardListTotCnt(BoardVO searchVO) {
		return boardDAO.selectBoardListTotCnt(searchVO);
	}

	public BoardVO selectLoginCheck(BoardVO searchVO) {
		return boardDAO.selectLoginCheck(searchVO);
	}

	public void insertReply(BoardVO vo) throws Exception {
		LOGGER.debug(vo.toString());
		boardDAO.insertReply(vo);
	}

	@Override
	public List<BoardVO> selectReplyList(BoardVO vo) throws Exception {
		return boardDAO.selectReplyList(vo);
	}

	public void updateBoardCount(BoardVO vo) throws Exception {
		boardDAO.updateBoardCount(vo);
	}
}
