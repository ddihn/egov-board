package board.web;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import board.service.BoardService;
import board.service.BoardVO;

@Controller
public class BoardController {

	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	@Resource(name = "boardService")
	private BoardService boardService;

	@RequestMapping("/mainList.do")
	public String list(@ModelAttribute("boardVO") BoardVO boardVO, ModelMap model) throws Exception {

		boardVO.setPageUnit(propertiesService.getInt("pageUnit"));
		boardVO.setPageSize(propertiesService.getInt("pageSize"));

		if (boardVO.getPageIndex() < 1) {
			boardVO.setPageIndex(1);
		}

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(boardVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(boardVO.getPageUnit());
		paginationInfo.setPageSize(boardVO.getPageSize());

		boardVO.setFirstIndex(Math.max(paginationInfo.getFirstRecordIndex(), 0));
		boardVO.setLastIndex(paginationInfo.getLastRecordIndex());
		boardVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> list = boardService.selectBoardList(boardVO);
		int totCnt = boardService.selectBoardListTotCnt(boardVO);

		paginationInfo.setTotalRecordCount(totCnt);

		model.addAttribute("resultList", list);
		model.addAttribute("paginationInfo", paginationInfo);

		return "mainList";
	}

	@RequestMapping("/view.do")
	public String goView(@ModelAttribute("boardVO") BoardVO boardVO, ModelMap model) throws Exception {
		boardVO = boardService.selectBoard(boardVO);

		List<BoardVO> replyList = boardService.selectReplyList(boardVO);
		boardService.updateBoardCount(boardVO);

		model.addAttribute("replyList", replyList);
		model.addAttribute("boardVO", boardVO);
		return "view";
	}

	@RequestMapping("/login.do")
	public String login(@RequestParam("user_id") String user_id, @RequestParam("password") String password,
			ModelMap model, HttpServletRequest request) throws Exception {

		BoardVO boardVO = new BoardVO();
		boardVO.setUserId(user_id);
		boardVO.setPassword(password);

		BoardVO resultVO = boardService.selectLoginCheck(boardVO);

		if (resultVO != null && resultVO.getUserName() != null && !"".equals(resultVO.getUserName())) {
			request.getSession().setAttribute("userId", resultVO.getUserId());
			request.getSession().setAttribute("userName", resultVO.getUserName());
		} else {
			request.getSession().invalidate();
			model.addAttribute("msg", "사용자 정보가 올바르지 않습니다.");
		}

		return "redirect:/mainList.do";
	}

	@RequestMapping("/logout.do")
	public String logout(HttpServletRequest request) throws Exception {
		request.getSession().invalidate();
		return "redirect:/mainList.do";
	}

	// 등록/수정 화면 이동
	@RequestMapping(value = "/mgmt.do", method = RequestMethod.GET)
	public String showWritePage(@ModelAttribute("boardVO") BoardVO boardVO,
			@RequestParam(value = "mode", required = false, defaultValue = "add") String mode, ModelMap model,
			HttpServletRequest request) throws Exception {

		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String strToday = sdf.format(Calendar.getInstance().getTime());

		Object userIdObj = request.getSession().getAttribute("userId");
		Object userNameObj = request.getSession().getAttribute("userName");

		if (userIdObj == null || userNameObj == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			return "redirect:/mainList.do";
		}

		boardVO.setWriter(userIdObj.toString());
		boardVO.setWriterNm(userNameObj.toString());
		boardVO.setIndate(strToday);

		// mode=modify인 경우, DB에서 기존 게시글 조회
		if ("modify".equals(mode)) {
			boardVO = boardService.selectBoard(boardVO);
		}

		model.addAttribute("boardVO", boardVO);
		model.addAttribute("mode", mode); // jsp에서 버튼 분기용
		return "mgmt";
	}

	// 등록/수정/삭제 처리
	@RequestMapping(value = "/mgmt.do", method = RequestMethod.POST)
	public String handleMgmt(@ModelAttribute("boardVO") BoardVO boardVO, @RequestParam("mode") String mode,
			HttpServletRequest request) throws Exception {
		System.out.println("🔥 [DEBUG] mode: " + mode);
		System.out.println("🔥 [DEBUG] idx: " + boardVO.getIdx());

		Object userId = request.getSession().getAttribute("userId");
		Object userName = request.getSession().getAttribute("userName");

		if (userId != null)
			boardVO.setWriter(userId.toString());
		if (userName != null)
			boardVO.setWriterNm(userName.toString());

		boardVO.setIndate(new SimpleDateFormat("yyyyMMdd").format(new Date()));

		switch (mode) {
		case "add":
			boardService.insertBoard(boardVO);
			break;
		case "modify":
			boardService.updateBoard(boardVO);
			break;
		case "del":
			boardService.deleteBoard(boardVO);
			break;
		}

		return "redirect:/mainList.do";
	}

	// 댓글 등록
	@RequestMapping(value = "/reply.do", method = RequestMethod.POST)
	public String insertReply(@ModelAttribute("boardVO") BoardVO boardVO, HttpServletRequest request) throws Exception {

		String userId = (String) request.getSession().getAttribute("userId");
		boardVO.setWriter((userId != null && !userId.isEmpty()) ? userId : "anonymous");
		boardVO.setIndate(new SimpleDateFormat("yyyyMMdd").format(new Date()));

		boardService.insertReply(boardVO);
		return "redirect:/view.do?idx=" + boardVO.getIdx();
	}
}
