<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>detail.jsp</title>
    <script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
</head>
<body>
<table>
    <tr>
        <th>id</th>
        <td>${board.id}</td>
    </tr>
    <tr>
        <th>writer</th>
        <td>${board.boardWriter}</td>
    </tr>
    <tr>
        <th>date</th>
        <td>${board.boardCreatedTime}</td>
    </tr>
    <tr>
        <th>hits</th>
        <td>${board.boardHits}</td>
    </tr>
    <tr>
        <th>title</th>
        <td>${board.boardTitle}</td>
    </tr>
    <tr>
        <th>contents</th>
        <td>${board.boardContents}</td>
    </tr>
</table>
<button onclick="listFn()">목록</button>
<button onclick="updateFn()">수정</button>
<button onclick="deleteFn()">삭제</button>
<div>
    <input type="text" id="commentWriter" placeholder="작성자">
    <input type="text" id="commentContents" placeholder="내용">
    <button id="comment-write-btn" onclick="commentWrite()">댓글작성</button>
</div>
<div id="comment-list">
    <table>
        <tr>
            <th>댓글번호</th>
            <th>작성자</th>
            <th>내용</th>
            <th>작성시간</th>
            <th>수정</th>
            <th>삭제</th>
        </tr>
        <c:forEach items="${commentList}" var="comment">
            <tr>
                <td>${comment.id}</td>
                <td>${comment.commentWriter}</td>
                <td>${comment.commentContents}</td>
                <td>${comment.commentCreatedTime}</td>
                <td><button onclick="updateComment(${comment.id}, '${comment.commentWriter}', '${comment.commentContents}')">수정</button></td>
                <td><button onclick="deleteComment(${comment.id}, ${comment.boardId})">삭제</button></td>
            </tr>
        </c:forEach>
    </table>
</div>
</body>
<script>
    const listFn = () => {
        const page = '${page}';
        location.href = "/board/paging?page=" + page;
    }
    const updateFn = () => {
        const id = '${board.id}';
        location.href = "/board/update?id=" + id;
    }
    const deleteFn = () => {
        const id = '${board.id}';
        location.href = "/board/delete?id=" + id;
    }
    const commentWrite = () => {
        const writer = document.getElementById("commentWriter").value;
        const contents = document.getElementById("commentContents").value;
        const board = '${board.id}';
        $.ajax({
            type: "post",
            url: "/comment/save",
            data: {
                commentWriter: writer,
                commentContents: contents,
                boardId: board
            },
            dataType: "json",
            success: function(commentList) {
                console.log("작성성공");
                console.log(commentList);
                let output = "<table>";
                output += "<tr><th>댓글번호</th>";
                output += "<th>작성자</th>";
                output += "<th>내용</th>";
                output += "<th>작성시간</th>";
                output += "<th>수정</th>";
                output += "<th>삭제</th></tr>";
                for(let i in commentList){
                    output += "<tr>";
                    output += "<td>"+commentList[i].id+"</td>";
                    output += "<td>"+commentList[i].commentWriter+"</td>";
                    output += "<td>"+commentList[i].commentContents+"</td>";
                    output += "<td>"+commentList[i].commentCreatedTime+"</td>";
                    output += "<td><button onclick=\"updateComment("+commentList[i].id+", '"+commentList[i].commentWriter+"', '"+commentList[i].commentContents+"')\">수정</button></td>";
                    output += "<td><button onclick=\"deleteComment("+commentList[i].id+", "+commentList[i].boardId+")\">삭제</button></td>";
                    output += "</tr>";
                }
                output += "</table>";
                document.getElementById('comment-list').innerHTML = output;
                document.getElementById('commentWriter').value='';
                document.getElementById('commentContents').value='';
            },
            error: function() {
                console.log("실패");
            }
        });
    }

    const updateComment = (commentId, writer, contents) => {
        // 댓글 수정 폼을 동적으로 생성하여 출력
        let form = "<form id='updateForm'>";
        form += "<input type='text' id='updateWriter' value='"+writer+"'>";
        form += "<input type='text' id='updateContents' value='"+contents+"'>";
        form += "<button type='button' onclick='updateCommentAction("+commentId+")'>수정 완료</button>";
        form += "</form>";
        document.getElementById('comment-list').innerHTML = form;
    }

    const updateCommentAction = (commentId) => {
        // 수정된 댓글 정보를 가져와서 수정 작업 수행
        const writer = document.getElementById("updateWriter").value;
        const contents = document.getElementById("updateContents").value;
        const board = '${board.id}';
        $.ajax({
            type: "post",
            url: "/comment/update",
            data: {
                id: commentId,
                commentWriter: writer,
                commentContents: contents,
                boardId: board
            },
            dataType: "json",
            success: function(commentList) {
                console.log("수정성공");
                console.log(commentList);
                let output = "<table>";
                output += "<tr><th>댓글번호</th>";
                output += "<th>작성자</th>";
                output += "<th>내용</th>";
                output += "<th>작성시간</th>";
                output += "<th>수정</th>";
                output += "<th>삭제</th></tr>";
                for(let i in commentList){
                    output += "<tr>";
                    output += "<td>"+commentList[i].id+"</td>";
                    output += "<td>"+commentList[i].commentWriter+"</td>";
                    output += "<td>"+commentList[i].commentContents+"</td>";
                    output += "<td>"+commentList[i].commentCreatedTime+"</td>";
                    output += "<td><button onclick=\"updateComment("+commentList[i].id+", '"+commentList[i].commentWriter+"', '"+commentList[i].commentContents+"')\">수정</button></td>";
                    output += "<td><button onclick=\"deleteComment("+commentList[i].id+", "+commentList[i].boardId+")\">삭제</button></td>";
                    output += "</tr>";
                }
                output += "</table>";
                document.getElementById('comment-list').innerHTML = output;
            },
            error: function() {
                console.log("실패");
            }
        });
    }

    const deleteComment = (commentId, boardId) => {
        // 댓글 삭제 작업을 수행
        $.ajax({
            type: "post",
            url: "/comment/delete",
            data: {
                commentId: commentId,
                boardId: boardId
            },
            dataType: "json",
            success: function(commentList) {
                console.log("삭제성공");
                console.log(commentList);
                let output = "<table>";
                output += "<tr><th>댓글번호</th>";
                output += "<th>작성자</th>";
                output += "<th>내용</th>";
                output += "<th>작성시간</th>";
                output += "<th>수정</th>";
                output += "<th>삭제</th></tr>";
                for(let i in commentList){
                    output += "<tr>";
                    output += "<td>"+commentList[i].id+"</td>";
                    output += "<td>"+commentList[i].commentWriter+"</td>";
                    output += "<td>"+commentList[i].commentContents+"</td>";
                    output += "<td>"+commentList[i].commentCreatedTime+"</td>";
                    output += "<td><button onclick=\"updateComment("+commentList[i].id+", '"+commentList[i].commentWriter+"', '"+commentList[i].commentContents+"')\">수정</button></td>";
                    output += "<td><button onclick=\"deleteComment("+commentList[i].id+", "+commentList[i].boardId+")\">삭제</button></td>";
                    output += "</tr>";
                }
                output += "</table>";
                document.getElementById('comment-list').innerHTML = output;
            },
            error: function() {
                console.log("실패");
            }
        });
    }
</script>
</html>