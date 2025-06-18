<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url var="mainListURL" value="/mainList.do" />
<c:url var="mgmtURL" value="/mgmt.do" />
<!DOCTYPE html>
<html>
<head>
  <title>게시판 작성</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script>
	function cancel() {
		location.href = "${mainListURL}";
	}

	$(document).ready(function () {
		$("#writerNm").attr("readonly", true);
		$("#indate").attr("readonly", true);
	});

	function add() {
		if ($("#title").val() === '') {
			alert("제목을 입력하세요");
			$("#title").focus();
			return;
		}
		if ($("#contents").val() === '') {
			alert("내용을 입력하세요");
			$("#contents").focus();
			return;
		}
		if (!confirm("등록하시겠습니까?")) {
			return;
		}
		document.boardRegForm.submit();
	}

	function modify() {
		if ($("#title").val() === '') {
			alert("제목을 입력하세요");
			$("#title").focus();
			return;
		}
		if ($("#contents").val() === '') {
			alert("내용을 입력하세요");
			$("#contents").focus();
			return;
		}
		if (!confirm("수정하시겠습니까?")) {
			return;
		}
		document.boardRegForm.submit();
	}
  </script>
</head>
<body>
<div class="container mt-4">
  <h1 class="mb-4">게시판 ${mode eq 'modify' ? '수정' : '등록'}</h1>

  <div class="card">
    <div class="card-header">
      <label>${sessionScope.userName} 님이 로그인 하셨습니다.</label>
    </div>

    <div class="card-body">
      <form method="post" name="boardRegForm" action="${mgmtURL}">
		  <!-- 반드시 이 순서로 -->
		  <input type="hidden" name="mode" value="${mode}" />
		  <input type="hidden" name="idx" value="${boardVO.idx}" />
			<div class="row mb-3">
			  <label class="col-sm-2 col-form-label">게시물 아이디:</label>
			  <div class="col-sm-10">
			    <input
			      type="text"
			      class="form-control"
			      value="${not empty boardVO.idx ? boardVO.idx : ''}"
			      readonly
			      placeholder="자동 발번"
			    />
			  </div>
			</div>
        <div class="row mb-3">
          <label for="title" class="col-sm-2 col-form-label">제목:</label>
          <div class="col-sm-10">
            <input type="text" class="form-control" id="title" name="title"
                   value="${boardVO.title}" maxlength="100" placeholder="제목을 입력하세요" />
          </div>
        </div>

        <div class="row mb-3">
          <label class="col-sm-2 col-form-label">등록자/등록일:</label>
          <div class="col-sm-10 d-flex align-items-center flex-wrap">
            <input type="hidden" name="writer" value="${boardVO.writer}" />
            <input type="text" class="form-control me-2 mb-1" id="writerNm" name="writerNm"
                   value="${boardVO.writerNm}" style="width:40%;" readonly />
            <input type="text" class="form-control mb-1" id="indate" name="indate"
                   value="${boardVO.indate}" style="width:40%;" readonly />
          </div>
        </div>

        <div class="row mb-3">
          <label for="contents" class="col-sm-2 col-form-label">내용:</label>
          <div class="col-sm-10">
            <textarea class="form-control" rows="5" id="contents" name="contents" maxlength="1000">${boardVO.contents}</textarea>
          </div>
        </div>

        <div class="card-footer text-end">
          <c:if test="${!empty sessionScope.userId}">
            <c:choose>
              <c:when test="${mode eq 'modify'}">
                <button type="button" class="btn btn-secondary" onClick="modify();">수정</button>
              </c:when>
              <c:otherwise>
                <button type="button" class="btn btn-secondary" onClick="add();">등록</button>
              </c:otherwise>
            </c:choose>
          </c:if>
          <button type="button" class="btn btn-outline-secondary" onClick="cancel();">취소</button>
        </div>
      </form>
    </div>
  </div>
</div>
</body>
</html>
