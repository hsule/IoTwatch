using Toybox.WatchUi;
using Toybox.Communications as Comm;
using Toybox.Sensor;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time.Gregorian;
using Toybox.Sensor;
using Toybox.Application;
using Toybox.Position;
using Toybox.Timer;

class IoTWatchView extends WatchUi.View {
    var dataTimer = new Timer.Timer();
    var string_HR;

    //Fill in this variable with the time interval in ms that you want to use for submitting data. Lower values will cause more calls so will cost more!
    var timer = 5000;
    
    function initialize() {
        View.initialize();
        register();
        // Set up a timer
        dataTimer.start(method(:timerCallback), timer, true);
    }

    function register() {
        var params = {
            "profile" =>
            {
                "d_name" => "IoTWatch",
                "dm_name" => "IoTWatch",
                "u_name" => "yb",
                "is_sim" => false,
                "df_list" => ["IoTWatch-i", "IoTWatch-o"]
            }
        };
        var headers = {
            "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
        };
        var options = {
            :headers => headers,
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        var responseCallback = method(:onReceive);
        Communications.makeWebRequest("http://demo.iottalk.tw:9999/IoTWatch", params, options, method(:onReceive));
        // Communications.makeWebRequest("https://demo.iottalk.tw/IoTWatch", params, options, method(:onReceive));
        // Communications.makeWebRequest("http://192.168.217.1:3000/posts", params, options, method(:onReceive));
    }
    
    function timerCallback() {
        var sensorInfo = Sensor.getInfo();
        var positionInfo = Position.getInfo();
        var xAccel = 0;
        var yAccel = 0;
        var hR = 0;
        var altitude = 0;
        var cadence = 0;
        var heading = 0;
        var xMag = 0;
        var yMag = 0;
        var zMag = 0;
        var power = 0;
        var pressure = 0;
        var speed = 0;
        var temp = 0;
        var latitude = 0;
        var longitude = 0;
    
    //Collect Data
    //Accelerometer
    if (sensorInfo has :accel && sensorInfo.accel != null) {
        var accel = sensorInfo.accel;
        xAccel = accel[0];
        yAccel = accel[1];
    }
    else {
        xAccel = 0;
        yAccel = 0;
    }
    //Heartrate
    if (sensorInfo has :heartRate && sensorInfo.heartRate != null) {
        hR = sensorInfo.heartRate;
    }
    else {
        hR = 0;
    }
    //Altitude
    if (sensorInfo has :altitude && sensorInfo.altitude != null) {
        altitude = sensorInfo.altitude;
    }
    else {
        altitude = 0;
    }
    //Cadence
    if (sensorInfo has :cadence && sensorInfo.cadence != null) {
        cadence = sensorInfo.cadence;
    }
    else {
        cadence = 0;
    }
    //heading
    if (sensorInfo has :heading && sensorInfo.heading != null) {
        heading = sensorInfo.heading;
    }
    else {
        heading = 0;
    }
    //magnetometer
    if (sensorInfo has :mag && sensorInfo.mag != null) {
        var mag = sensorInfo.mag;
        xMag = mag[0];
        yMag = mag[1];
        zMag = mag[2];
    }
    else {
        xMag = 0;
        yMag = 1;
        zMag = 2;
    }
    //Power
    if (sensorInfo has :power && sensorInfo.power != null) {
        power = sensorInfo.power;
    }
    else {
        power = 0;
    }
    //Pressure
    if (sensorInfo has :pressure && sensorInfo.pressure != null) {
        pressure = sensorInfo.pressure;
    }
    else {
        pressure = 0;
    }
    //Speed
    if (sensorInfo has :speed && sensorInfo.speed != null) {
        speed = sensorInfo.speed;
    }
    else {
        speed = 0;
    }
    //Temperature
    if (sensorInfo has :temp && sensorInfo.temp != null) {
        temp = sensorInfo.temp;
    }
    else {
        temp = 0;
    }
    //Position
    if (positionInfo has :position && positionInfo.position != null) {
        var location = positionInfo.position.toDegrees();
        latitude = location[0];
        longitude = location[1];
    }
    else {
        latitude = 0;
        longitude = 0;

    }

    //Send the data to the REST API
    var params = {
        "data" => [
            hR.toNumber(),
            xAccel.toNumber(),
            yAccel.toNumber(),
            altitude.toFloat(),
            cadence.toNumber(),
            heading.toFloat(),
            xMag.toNumber(),
            yMag.toNumber(),
            zMag.toNumber(),
            power.toNumber(),
            pressure.toFloat(),
                speed.toFloat(),
                temp.toNumber(),
                latitude.toFloat(),
                longitude.toFloat()
            ]
        };
        var headers = {
            "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
        };
        var options = {
            :headers => headers,
            :method => Communications.HTTP_REQUEST_METHOD_PUT,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        // Communications.makeWebRequest ("https://demo.iottalk.tw/IoTWatch/IoTWatch-i", params, options, method(:onReceive));
        Communications.makeWebRequest("http://demo.iottalk.tw:9999/IoTWatch/IoTWatch-i", params, options, method(:onReceive));
    }
        
        function onReceive(responseCode, data) {
            if (responseCode == 200) {
                System.println( "successful\n" );
                System.println(data);
            } else {
                if (data != null) {
                    System.println("error");
                    System.println(responseCode);
                    System.println(data );
                } else {
                    System.println( "nodata" );
                    System.println(responseCode);
                }
            }
            WatchUi.requestUpdate();
        }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
      View.onUpdate(dc);
    }

    function onHide() {
    }

}
