package vn.iotstar.service.impl;

import java.util.List;
import vn.iotstar.dao.IVideoDao;
import vn.iotstar.dao.impl.VideoDaoImpl;
import vn.iotstar.model.Video;
import vn.iotstar.service.IVideoService;

public class VideoServiceImpl implements IVideoService {
    private final IVideoDao videoDao = new VideoDaoImpl();

    @Override
    public void insert(Video video) {
        Video existing = videoDao.findById(video.getVideoId());
        if (existing == null) {
            videoDao.insert(video);
        }
    }

    @Override
    public void update(Video video) {
        Video existing = videoDao.findById(video.getVideoId());
        if (existing != null) {
            videoDao.update(video);
        }
    }

    @Override
    public void delete(String videoId) throws Exception {
        videoDao.delete(videoId);
    }

    @Override
    public Video findById(String videoId) {
        return videoDao.findById(videoId);
    }

    @Override
    public List<Video> findAll() {
        return videoDao.findAll();
    }

    @Override
    public List<Video> findAll(int page, int pageSize) {
        return videoDao.findAll(page, pageSize);
    }

    @Override
    public List<Video> findTop10Latest() {
        return videoDao.findTop10Latest();
    }

    @Override
    public List<Video> searchByTitle(String keyword) {
        return videoDao.searchByTitle(keyword);
    }

    @Override
    public Video findByTitle(String title) {
        try {
            return videoDao.findByTitle(title);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public int count() {
        return videoDao.count();
    }
}
