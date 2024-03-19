#ifndef FLUTTER_PLUGIN_QR_IMAGE_READER_AURORA_PLUGIN_H
#define FLUTTER_PLUGIN_QR_IMAGE_READER_AURORA_PLUGIN_H

#include <flutter/plugin-interface.h>
#include <qr_image_reader_aurora/globals.h>

class PLUGIN_EXPORT QrImageReaderAuroraPlugin final : public PluginInterface
{
public:
    void RegisterWithRegistrar(PluginRegistrar &registrar) override;

private:
    void onMethodCall(const MethodCall &call);
    void onAnalyzeImage(const MethodCall &call);
    void unimplemented(const MethodCall &call);
    std::string readBarcode(uint8_t* bits, int width, int height);
};

#endif /* FLUTTER_PLUGIN_QR_IMAGE_READER_AURORA_PLUGIN_H */
