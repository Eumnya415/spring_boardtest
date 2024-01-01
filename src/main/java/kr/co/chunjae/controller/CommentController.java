package kr.co.chunjae.controller;

import kr.co.chunjae.dto.CommentDTO;
import kr.co.chunjae.service.CommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/comment")
public class CommentController {

    private final CommentService commentService;

    @PostMapping("/save")
    public @ResponseBody List<CommentDTO> save(@ModelAttribute CommentDTO commentDTO) {
        System.out.println("commentDTO = " + commentDTO);
        commentService.save(commentDTO);
        // 해당 게시글에 작성된 댓글 리스트를 가져옴
        List<CommentDTO> commentDTOList = commentService.findAll(commentDTO.getBoardId());
        return commentDTOList;
    }

    @PostMapping("/update")
    public @ResponseBody List<CommentDTO> update(@ModelAttribute CommentDTO commentDTO) {
        commentService.update(commentDTO);
        List<CommentDTO> commentDTOList = commentService.findAll(commentDTO.getBoardId());
        return commentDTOList;
    }

    @PostMapping("/delete")
    public @ResponseBody List<CommentDTO> delete(@RequestParam Long commentId, @RequestParam Long boardId) {
        commentService.delete(commentId);
        List<CommentDTO> commentDTOList = commentService.findAll(boardId);
        return commentDTOList;
    }
}