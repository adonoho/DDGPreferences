//
//  DDGProperties.c
//  DDGPreferences
//
//  Created by Andrew Donoho on 2014/08/30.
//  Copyright (c) 2014 Donoho Design Group, L.L.C. All rights reserved.
//

#include <string.h>

#include "DDGProperties.h"

inline bool supportedPropName(const char *propName) {

    return (strcmp(propName, "hash") != 0 &&
            strcmp(propName, "dirty") != 0 &&
            strcmp(propName, "superclass") != 0 &&
            strcmp(propName, "settingsKeys") != 0 &&
            strcmp(propName, "description") != 0 &&
            strcmp(propName, "debugDescription") != 0);

} // supportedPropName()
