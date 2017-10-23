package com.it.utility;

/**
 * Created by admin on 4/19/2016.
 */
public class GetterSetter {

    public String _id,_name,_image,_blank;
    public int _imageSel;
    public String _videoId, _smallTitle, _fullTitle, _urlVideo, _watched,
            _liked, _wlater, _thumb, _duration, _userLink, _userName, _views,
            _timeAgo;
    public int _imageSet;

    public GetterSetter(String id,String name,int imageSel){

        this._id = id;
        this._name = name;
        this._imageSel = imageSel;

    }

    public GetterSetter(String id,String name,String image,String blank){

        this._id = id;
        this._name = name;
        this._image = image;
        this._blank = blank;

    }

    public GetterSetter(String videoId, String smallTitle, String fullTitle,
                        String urlVideo, String watched, String liked, String wlater,
                        String thumb, String duration, String userLink, String userName,
                        String views, String timeAgo) {

        this._videoId = videoId;
        this._smallTitle = smallTitle;
        this._fullTitle = fullTitle;
        this._urlVideo = urlVideo;
        this._watched = watched;
        this._liked = liked;
        this._wlater = wlater;
        this._thumb = thumb;
        this._duration = duration;
        this._userLink = userLink;
        this._userName = userName;
        this._views = views;
        this._timeAgo = timeAgo;

    }


}
