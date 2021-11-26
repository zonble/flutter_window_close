#include "include/flutter_window_close/flutter_window_close_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#define FLUTTER_WINDOW_CLOSE_PLUGIN(obj)                                       \
    (G_TYPE_CHECK_INSTANCE_CAST((obj), flutter_window_close_plugin_get_type(), \
        FlutterWindowClosePlugin))

struct _FlutterWindowClosePlugin {
    GObject parent_instance;
    GtkWidget* widget;
};

G_DEFINE_TYPE(FlutterWindowClosePlugin, flutter_window_close_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void flutter_window_close_plugin_handle_method_call(
    FlutterWindowClosePlugin* self,
    FlMethodCall* method_call)
{

    const gchar* method = fl_method_call_get_name(method_call);

    if (strcmp(method, "closeWindow") == 0) {
        g_autoptr(FlMethodResponse) response = nullptr;
        gtk_window_close((GtkWindow*)self->widget);
        response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
        fl_method_call_respond(method_call, response, nullptr);
    } else if (strcmp(method, "destroyWindow") == 0) {
        g_autoptr(FlMethodResponse) response = nullptr;
        response
            = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
        fl_method_call_respond(method_call, response, nullptr);
        gtk_widget_destroy((GtkWidget*)self->widget);
    } else {
        g_autoptr(FlMethodResponse) response = nullptr;
        response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
        fl_method_call_respond(method_call, response, nullptr);
    }
}

static void flutter_window_close_plugin_dispose(GObject* object)
{
    G_OBJECT_CLASS(flutter_window_close_plugin_parent_class)->dispose(object);
}

static void flutter_window_close_plugin_class_init(FlutterWindowClosePluginClass* klass)
{
    G_OBJECT_CLASS(klass)->dispose = flutter_window_close_plugin_dispose;
}

static void flutter_window_close_plugin_init(FlutterWindowClosePlugin* self) { }

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
    gpointer user_data)
{
    FlutterWindowClosePlugin* plugin = FLUTTER_WINDOW_CLOSE_PLUGIN(user_data);
    flutter_window_close_plugin_handle_method_call(plugin, method_call);
}

static FlMethodChannel* notificationChannel;

static gboolean
main_window_close(GtkWidget* window, gpointer data)
{
    FlValue* value = fl_value_new_null();
    fl_method_channel_invoke_method(notificationChannel,
        "onWindowClose",
        value, NULL, NULL, NULL);
    return TRUE;
}

void flutter_window_close_plugin_register_with_registrar(FlPluginRegistrar* registrar)
{
    GtkWidget* window = gtk_widget_get_ancestor((GtkWidget*)fl_plugin_registrar_get_view(registrar), GTK_TYPE_WINDOW);
    g_signal_connect(G_OBJECT(window), "delete_event",
        G_CALLBACK(main_window_close),
        NULL);

    FlutterWindowClosePlugin* plugin = FLUTTER_WINDOW_CLOSE_PLUGIN(
        g_object_new(flutter_window_close_plugin_get_type(), nullptr));
    plugin->widget = window;

    g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
    g_autoptr(FlMethodChannel) channel = fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
        "flutter_window_close",
        FL_METHOD_CODEC(codec));
    fl_method_channel_set_method_call_handler(channel, method_call_cb,
        g_object_ref(plugin),
        g_object_unref);

    g_object_unref(plugin);

    notificationChannel = fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
        "flutter_window_close_notification",
        FL_METHOD_CODEC(codec));
}
