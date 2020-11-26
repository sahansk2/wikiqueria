#pragma once

#include <string>

namespace GraphADT{
    struct Vertex{    
        Vertex(size_t node_id, std::string page_name);
        bool operator==(const Vertex &other) const; 
        bool operator<(const Vertex &other) const;
         
        size_t node_id_, degree_;
        std::string page_name_;
    };
};