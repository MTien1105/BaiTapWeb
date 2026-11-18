package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.iotstar.model.Video;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.VideoServiceImpl;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = { "/home", "/index" })
public class HomeController extends HttpServlet {

    private final IVideoService videoService = new VideoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lấy 10 video mới nhất đang ở trạng thái hoạt động (Active = 1)
        List<Video> top10Videos = videoService.findTop10Latest();
        req.setAttribute("top10Videos", top10Videos);

        req.getRequestDispatcher("/views/home.jsp").forward(req, resp);
    }
}
