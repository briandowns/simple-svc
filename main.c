#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <stdio.h>
#include <strings.h>
#include <sys/socket.h>

#include <ulfius.h>

#include "deps/logger.h"

#define STR1(x) #x
#define STR(x) STR1(x)

#define U_DISABLE_WEBSOCKET

#define PORT 8080
#define HEALTHZ_PATH          "/healthz"
#define API_PREFIX            "/api/v1"
#define HELLO_PATH API_PREFIX "/hello"

#define HTTP_METHOD_GET "GET"

/**
 * callback_health_check handles all health check
 * requests to the service
 */
int
callback_health_check(const struct _u_request *request, struct _u_response *response, void *user_data)
{
    log(LOG_INFO, log_string("msg", "healthz called"), log_string("client_addr", inet_ntoa(((struct sockaddr_in *)request->client_address)->sin_addr)));
    json_t * json_body = json_object();
    json_object_set_new(json_body, "status", json_string("OK")); 
    json_object_set_new(json_body, "git_sha", json_string(STR(git_sha)));
    ulfius_set_json_body_response(response, 200, json_body);
    json_decref(json_body);
    return U_CALLBACK_CONTINUE;
}

/**
 * callback_relationships handles requests for hello.
 */
int
callback_hello(const struct _u_request *request, struct _u_response *response, void *user_data)
{
    log(LOG_INFO, log_string("msg", "hello endpoint called"), log_string("client_addr", inet_ntoa(((struct sockaddr_in *)request->client_address)->sin_addr)));
    json_t *json_body = json_object();
    json_object_set_new(json_body, "hello", json_string("world"));
    ulfius_set_json_body_response(response, 200, json_body);
    json_decref(json_body);
    return U_CALLBACK_CONTINUE;
}

int
main(int argc, char **argv)
{
    log_init(stdout);

    struct _u_instance instance;

    if (ulfius_init_instance(&instance, PORT, NULL, NULL) != U_OK) { 
        log(LOG_ERROR, log_string("msg", "error ulfius_init_instance, abort"));
        return 1;
    } 

    ulfius_add_endpoint_by_val(&instance, HTTP_METHOD_GET, HEALTHZ_PATH, NULL, 0, &callback_health_check, NULL);
    ulfius_add_endpoint_by_val(&instance, HTTP_METHOD_GET, HELLO_PATH, NULL, 1, &callback_hello, NULL);

    if (ulfius_start_framework(&instance) == U_OK) {
        log(LOG_INFO, log_string("msg", "starting framework"), log_int("port", instance.port));
        getchar();
    } else {
        log(LOG_ERROR, log_string("msg", "error starting framework"));
        return 1;
    }

    ulfius_stop_framework(&instance);
    ulfius_clean_instance(&instance);

    return 0;
}
