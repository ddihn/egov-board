<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:url var="replyURL" value="/reply.do" />
<c:url var="mgmtURL" value="/mgmt.do" />
<c:url var="mainListURL" value="/mainList.do" />
<!DOCTYPE html>
<html>
<head>
  <title>게시판 작성</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

  <script>
	function cancel(){
		location.href = "${mainListURL}";
	}
	function add() {
		if ($("#reply").val() === "") {
			alert("댓글을 입력하세요");
			$("#reply").focus();
			return;
		}
		if (!confirm("댓글을 작성하시겠습니까?")) {
			return;
		}
		document.form2.action = "${replyURL}";
		document.form2.submit();
	}
	function modify(){
		location.href = "${mgmtURL}";
	}
	function del(){
		var cnt = ${fn:length(resultList)};
		
		if(cnt>0){
			alert("댓글이 있는 게시물은 삭제할 수 없습니다.");
		}
		if(!confirm("삭제하시겠습니까?")){
			return;
		}
		document.form1.action = "${mgmtURL}?mode=del&idx=${boardVO.idx}";
		document.form1.submit();
	}
	function list(){
		location.href = "${mainListURL}";
	}
  </script>
</head>
<body>
<div class="container mt-4">
  <h1 class="mb-4">메인 화면</h1>

  <div class="card">
    <div class="card-header">
      <label> ${sessionScope.userName} 님이 로그인 하셨습니다.</label>
    </div>
	<div class="card-body">
	  <form name="form1" class="row g-3" method="post" action="/">
	    <div class="row mb-3">
	      <label class="col-sm-2 col-form-label" for="idx">게시물아이디:</label>
	      <div class="col-sm-10 d-flex align-items-center">
	        <c:out value="${boardVO.idx}" />
	      </div>
	    </div>

	    <div class="row mb-3">
	      <label class="col-sm-2 col-form-label" for="title">제목:</label>
	      <div class="col-sm-10 d-flex align-items-center">
	        <c:out value="${boardVO.title}" />
	      </div>
	    </div>

	    <div class="row mb-3">
	      <label class="col-sm-2 col-form-label">등록자/등록일:</label>
	      <div class="col-sm-10 d-flex align-items-center">
	        <c:out value="${boardVO.writerNm}" /> /
	        <c:out value="${fn:substring(boardVO.indate, 0, fn:length(boardVO.indate) - 2)}" />
	      </div>
	    </div>

	    <div class="row mb-3">
	      <label class="col-sm-2 col-form-label" for="contents">내용:</label>
	      <div class="col-sm-10">
	        <c:out value="${fn:replace(boardVO.contents, crcn, br)}" escapeXml="false" />
	      </div>
	    </div>
	  </form>
	</div>
    <div class="card-footer text-end">
		<c:if test="${!empty sessionScope.userId && sessionScope.userId == boardVO.writer}">
			<button type="button" class="btn btn-secondary" onClick="modify();">수정</button>
			<button type="button" class="btn btn-secondary" onClick="del();">삭제</button>
		</c:if>
		<button type="button" class="btn btn-secondary" onclick="list();">목록</button>
	</div>

    <div class="mt-3 p-4 bg-body-tertiary border rounded">
    	<form name="form2" method="post" action="/reply.do">
		  <input type="hidden" name="idx" value="${boardVO.idx}" />
		  <input type="hidden" name="writer" value="${sessionScope.userId != null ? sessionScope.userId : 'anonymous'}" />
		  <input type="hidden" name="indate" value="<fmt:formatDate value='${now}' pattern='yyyyMMdd'/>" />
		
		  <div class="row mb-3">
		    <label for="reply" class="col-sm-2 col-form-label">댓글</label>
		    <div class="col-sm-10">
		      <textarea type="text" class="form-control" rows="3" id="reply" name="reply" maxlength="300"></textarea>
		    </div>
		  </div>
		  <div class="text-end">
		    <button type="submit" class="btn btn-primary" onClick="add();">작성</button>
		  </div>
		</form>

		<c:forEach var="reply" items="${replyList}">
		    <div class="mb-2 border-bottom pb-2">
		        <strong><c:out value="${reply.writer}" /></strong> / ${fn:substring(reply.indate, 0, fn:length(reply.indate) - 2)}<br>
		        ${reply.reply}
		    </div>
		</c:forEach>
	</div>
  </div>
</div>
</body>
</html>
