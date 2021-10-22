import ballerina/http;

type Student record {
    string Name;
    int Grade;
};

service / on new http:Listener(9090) {

    // Json structure similar to { Name: val, Grade: 0 } will be mapped to `Student` type.
    resource function post extractName(@http:Payload Student student)
            returns json {
        string name = student.Name;
        return {Name: name};
    }

    resource function post extractCity(@http:Payload xml store) returns xml {
        // Extract a descendent element from a xml value.
        xml city = store/**/<city>;
        return city;
    }

    // p, q are values extracted from the path.
    resource function get pathParam/[string p]/[string q]() returns json {
        return {
            p,
            q
        };
    }

    // `val` extracted from http header.
    resource function get header(@http:Header string? val) returns json {
        return {value: val};
    }

    // Request object is also available for advance use cases.
    resource function get request_object(http:Request req) returns xml|error {
        string header = check req.getHeader("val");
        return xml `<header>${header}</header>`;
    }
}
