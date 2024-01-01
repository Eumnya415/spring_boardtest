package kr.co.chunjae.repository;

import kr.co.chunjae.dto.CommentDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class CommentRepository {

    private final SqlSessionTemplate sql;

    public void save(CommentDTO commentDTO) {
        sql.insert("Comment.save", commentDTO);
    }

    public void update(CommentDTO commentDTO) {
        sql.update("Comment.update", commentDTO);
    }

    public void delete(Long commentId) {
        sql.delete("Comment.delete", commentId);
    }

    public List<CommentDTO> findAll(Long boardId) {
        return sql.selectList("Comment.findAll", boardId);
    }
}
