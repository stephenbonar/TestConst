/* testconst.c - Demo program to see how constants an variables are assembled.
 * Copyright (C) 2024 Stephen Bonar
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <stdio.h>

/* Global string constant. */
const char* meaningOfUniverseString = "The meaning of the universe is: %i\n";

/* Global int constant. */
const int meaningOfUniverse = 42;

int main()
{
    /* Local int constant. */
    const int number = 1;

    /* Local large int constant. */
    const int largeNumber = 0xF3200000;

    /* Local string constant. */
    const char* numberString = "The number is: %i\n";

    /* Local int variable. */
    int mutableNumber = 10;

    mutableNumber = mutableNumber + 5;

    printf(numberString, number);
    printf(numberString, largeNumber);
    printf(numberString, mutableNumber);
    printf(meaningOfUniverseString, meaningOfUniverse);

    return 0;
}