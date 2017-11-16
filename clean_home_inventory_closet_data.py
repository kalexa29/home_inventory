# simple python script to restructure my home inventory closet data
# starting point is csv with box, category, sub category, item, color
# goal is to remove the word after the last comma in the item column and place it into the sub category column

# this is my attempt at a python script that has the exact same function as the perl script of the same name in this repository

# find nth occurrence of character
# params:
#   line = the string you're searching
#   char = the character you're looking for
#   n    = the occurrence of the character that you're interested in
def find_nth(line, char, n):
    i = 0
    index = 0
    while i <= n:
        index = line.find(char, index + 1)
        i += 1
        if i == n or index == -1:
            return index
            break

local_directory = '/Users/Katelynn/Documents/'                  # replace with local location of the repository
clothes_new = "box,category,sub_category,details,color\n";      # header row for new file

# open the local file
with open(local_directory + 'home_inventory/clothes_download.csv', 'r') as file1:
    next(file1)                                                 # skip first line
    
    # loop through the original file
    for line in file1:
        if (1 == 1):
            line = line.lower()                                     # make all letters lowercase for consistency
            arr = line.split(',')                                   # split the line into parts
            box = arr[0].upper()                                    # first bit is the box the item is in, also the only uppercase column
            category = arr[1]                                       # second bit is the top level category
            sub_category = '';
            item = '';
            color = '';

            if category == '':                                      # handle undefined items by moving sub_category to category
                category = arr[2];
            else:
                # get item bit
                item = line[find_nth(line, "\"", 1)+1:find_nth(line, "\"", 2)]
                arr_item = item.split(',')                          # split the item column into parts
                sub_category = arr_item[len(arr_item) - 1].strip()  # get the last piece of the item column and save it as the sub category

                # clean up item bit
                item = '';
                for i in range(len(arr_item) - 1):
                    item += arr_item[i].strip() + ", "
                item = item[:len(item)-1]
                item = item[:-1]

                # get color bit
                last_double_quote = find_nth(line, "\"", 4)
                if (last_double_quote == -1):
                    color = arr[len(arr)-1]
                    color = color.strip().replace("\"",'')
                else:
                    char_count = 0
                    color_index = 0
                    for i in range(len(arr)):
                        # count the characters of each array index
                        char_count += len(arr[i])
                        if (char_count <= last_double_quote <= char_count * 2):
                            color_index = i
                            break
                    
                    # clean up color bit
                    while color_index < len(arr):
                        if (arr[color_index].strip().replace("\"",'') == sub_category):
                            color_index += 1
                        else:
                            color_index
                        color += arr[color_index].strip().replace("\"",'') + ", "
                        color_index += 1
                    color = color[:-2]
            clothes_new += box + "," + category + "," + sub_category + ",\"" + item + "\",\"" + color + "\"\n";
print clothes_new;

# create new local file and write the cleaned up data to it
with open(local_directory + 'home_inventory/clothes_new_python.csv', 'w') as file2:
    file2.write(clothes_new)