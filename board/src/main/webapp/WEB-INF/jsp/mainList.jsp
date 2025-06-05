<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>게시판 메인</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	
	<c:url var="mgmtUrl" value="/mgmt.do" />
	<c:url var="viewUrl" value="/view.do?idx=" />
	<c:url var="outUrl" value="/logout.do" />
	
	<script>
	function add(){
		location.href = "${mgmtUrl}";
	}
	function view(idx){
		location.href = "${viewUrl}"+idx;
	}
	function out(){
		location.href="${outUrl}";
	}
	function setPwd(user_id){
		$("#password").val("1234");
	}
	function check(){
		if($("#user_id").val() == ""){
			alert("아이디를 입력하세요");
			return false;
		}
		if($("#password").val() == ""){
			alert("비밀번호를 입력하세요");
			return false;
		}
		return true;
	}
	function page(pageNo){
		location.href = "<c:url value='/mainList.do'/>?pageIndex=" + pageNo;
	}
	</script>
</head>
<body>
<div class="container">
	<h1 class="mb-4">메인 화면</h1>

	<div class="card mb-4">
		<div class="card-header">
			<c:if test="${empty sessionScope.userId}">
				<form class="row g-3 align-items-end" method="post" action="/login.do">
					<div class="col-md-4">
						<label for="user_id" class="form-label">아이디</label>
						<select class="form-select" id="user_id" name="user_id" onchange="setPwd(this.value);">
							<option value="">선택하세요</option>
							<option value="admin">관리자</option>
							<option value="guest">사용자</option>
						</select>
					</div>
					<div class="col-md-4">
						<label for="password" class="form-label">비밀번호</label>
						<input type="password" class="form-control" id="password" name="password">
					</div>
					<div class="col-md-4">
						<button type="submit" class="btn btn-primary" onclick="return check();">로그인</button>
					</div>
				</form>
			</c:if>
			<c:if test="${!empty sessionScope.userId}">
				<div class="d-flex justify-content-between align-items-center">
					<div><strong>${sessionScope.userName}</strong>님 환영합니다</div>
					<button type="button" class="btn btn-secondary" onclick="out();">로그아웃</button>
				</div>
			</c:if>
		</div>

		<div class="card-body">
			<form class="row g-3 mb-4" method="post" action="/mainList.do">
				<div class="col-md-6">
					<label for="searchKeyword" class="form-label">제목</label>
					<input type="text" class="form-control" id="searchKeyword" name="searchKeyword">
				</div>
				<div class="col-md-6 d-flex align-items-end">
					<button type="submit" class="btn btn-secondary">검색</button>
				</div>
			</form>

			<div class="table-responsive">
				<table class="table table-hover">
					<thead class="table-light">
						<tr>
							<th>게시물 번호</th>
							<th>제목</th>
							<th>조회수</th>
							<th>댓글 수</th>
							<th>등록자</th>
							<th>등록일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="result" items="${resultList}">
						<tr>
							<td><a href="javascript:view('${result.idx}');"><c:out value="${result.idx}"/></a></td>
							<td><a href="javascript:view('${result.idx}');"><c:out value="${result.title}"/></a></td>
							<td><c:out value="${result.count}"/></td>
							<td><c:out value="${result.reply}"/></td>
							<td><c:out value="${result.writerNm}"/></td>
							<td><c:out value="${result.indate}"/></td>
						</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>

			<!-- ✅ 페이징 영역 -->
			<div class="d-flex justify-content-center mt-4">
				<nav>
					<ul class="pagination">
						<c:if test="${paginationInfo.firstPageNoOnPageList > 1}">
							<li class="page-item">
								<a class="page-link" href="javascript:page(${paginationInfo.firstPageNoOnPageList - 1});">이전</a>
							</li>
						</c:if>

						<c:forEach begin="${paginationInfo.firstPageNoOnPageList}" end="${paginationInfo.lastPageNoOnPageList}" var="pageNo">
							<li class="page-item <c:if test='${pageNo == paginationInfo.currentPageNo}'>active</c:if>">
								<a class="page-link" href="javascript:page(${pageNo});">${pageNo}</a>
							</li>
						</c:forEach>

						<c:if test="${paginationInfo.lastPageNoOnPageList < paginationInfo.totalPageCount}">
							<li class="page-item">
								<a class="page-link" href="javascript:page(${paginationInfo.lastPageNoOnPageList + 1});">다음</a>
							</li>
						</c:if>
					</ul>
				</nav>
			</div>

		</div>

		<div class="card-footer text-end">
			<c:if test="${!empty sessionScope.userId}">
				<button type="button" class="btn btn-outline-secondary" onclick="add();">등록</button>
			</c:if>
		</div>
	</div>
</div>
</body>
</html>
