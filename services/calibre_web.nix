{
  services.calibre-web = {
    enable = true;
    listen = {
      ip = "127.0.0.1";
      port = 8083;
    };
    options = {
      calibreLibrary = "/mnt/lethe/calibre";
      enableBookUploading = true;
      enableBookConversion = true;
      enableKepubify = true;
    };
  };
}
