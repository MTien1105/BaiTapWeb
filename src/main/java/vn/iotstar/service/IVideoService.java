package vn.iotstar.service;

import java.util.List;
import vn.iotstar.model.Video;

public interface IVideoService {
    void insert(Video video);
    void update(Video video);
    void delete(String videoId) throws Exception;
    Video findById(String videoId);
    List<Video> findAll();
    List<Video> findAll(int page, int pageSize);
    List<Video> findTop10Latest();
    List<Video> findByUserId(int userId, int page, int pageSize);
    int countByUserId(int userId);
    List<Video> findAllActivePaginated(int page, int pageSize);
    int countActive();
    List<Video> searchByTitle(String keyword);
    Video findByTitle(String title);
    int count();
}
