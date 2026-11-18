package vn.iotstar.model;

import java.io.Serializable;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;

@Entity
@Table(name = "Videos")
@NamedQuery(name = "Video.findAll", query = "SELECT v FROM Video v")
public class Video implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "VideoId", length = 50)
    private String videoId;

    @Column(name = "Active")
    private int active = 1;

    @Column(name = "Description", columnDefinition = "NVARCHAR(500) NULL")
    private String description;

    @Column(name = "Poster", columnDefinition = "NVARCHAR(500) NULL")
    private String poster;

    @Column(name = "Title", columnDefinition = "NVARCHAR(500) NULL")
    private String title;

    @Column(name = "Views")
    private int views = 0;

    // Mối quan hệ N-1: Nhiều Video thuộc về 1 User
    @ManyToOne
    @JoinColumn(name = "UserId", nullable = false)
    private User user;

    public Video() {
    }

    public Video(String videoId, String title, String description, String poster, int views, int active, User user) {
        this.videoId = videoId;
        this.title = title;
        this.description = description;
        this.poster = poster;
        this.views = views;
        this.active = active;
        this.user = user;
    }

    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public int getActive() {
        return active;
    }

    public void setActive(int active) {
        this.active = active;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getViews() {
        return views;
    }

    public void setViews(int views) {
        this.views = views;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return "Video [videoId=" + videoId + ", title=" + title + ", active=" + active + ", views=" + views + "]";
    }
}
