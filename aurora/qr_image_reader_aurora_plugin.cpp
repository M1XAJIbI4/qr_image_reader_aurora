#include <qr_image_reader_aurora/qr_image_reader_aurora_plugin.h>
#include <flutter/method-channel.h>
#include <sys/utsname.h>
#include <iostream>
#include <fstream>

#include "ZXing/ReadBarcode.h"

#define cimg_display 0
#define cimg_use_png
#define cimg_use_tiff
#define cimg_use_jpeg
#include <CImg.h>

void QrImageReaderAuroraPlugin::RegisterWithRegistrar(PluginRegistrar &registrar)
{
    registrar.RegisterMethodChannel("qr_image_reader_aurora",
                                    MethodCodecType::Standard,
                                    [this](const MethodCall &call)
                                    { this->onMethodCall(call); });
}

void QrImageReaderAuroraPlugin::onMethodCall(const MethodCall &call)
{
    const auto &method = call.GetMethod();
    if (method == "analyzeImage")
    {
        onAnalyzeImage(call);
        return;
    }
    unimplemented(call);
}

void QrImageReaderAuroraPlugin::onAnalyzeImage(const MethodCall &call)
{
    auto path = call.GetArgument<Encodable::String>("imagePath");

    std::cout << path << std::endl;
    std::ifstream file(path);
    if (!file.is_open())
    {
        std::cout << "File not found" << std::endl;
        call.SendErrorResponse("File not found", "", "");
        return;
    }

    std::vector<uint8_t> pixels;
    cimg_library::CImg<unsigned char> image;
    const char *pathData = path.data();
    image.load(pathData);

    unsigned char *img1 = image.data();
    ulong i = 0;
    for (i = 0; i < image.size(); i++)
    {
        auto pix = *(img1 + i);
        pixels.push_back(pix);
    }

    std::string result;
    ZXing::ImageView imageView = ZXing::ImageView(
        pixels.data(),
        image.width(),
        image.height(),
        ZXing::ImageFormat::RGBX);

    auto hints = ZXing::DecodeHints().setFormats(ZXing::BarcodeFormat::QRCode);
    ZXing::Result scanResult;
    try
    {
        scanResult = ZXing::ReadBarcode(imageView, hints);
        auto ws = scanResult.text();
        std::string scanText(ws.begin(), ws.end());
        result = scanText;
        std::cout << "ANALYZE IMAGE RESULT: " << result << std::endl;
    }
    catch (const char *err)
    {
        result = "";
    }

    call.SendSuccessResponse(result);
}

void QrImageReaderAuroraPlugin::unimplemented(const MethodCall &call)
{
    call.SendSuccessResponse(nullptr);
}
