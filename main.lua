local str = ""
while true do
  local inp = io.read()
  if inp == nil then break else str = str .. inp .. "\n" end
end

local opt = arg[1]
local option = ""

if opt == "line" then
  option = "l"
elseif opt == "space" then
  option = "s"
elseif opt == "custom" then
  option = "c"
else
  print("Invalid option")
  os.exit(1)
end

opt = nil

local hndl = {
  line = function (str)
    local str_buffer = ""
    local args = {}

    for i = 1, #str do
      local current_str = string.sub(str, i, i)

      if current_str == "\n" then
        table.insert(args, str_buffer)
        str_buffer = ""
      else
        str_buffer = str_buffer .. current_str
      end
    end
    return args
  end,

  space = function (str)
    local str_buffer = ""
    local args = {}

    for i = 1, #str do
      local current_str = string.sub(str, i, i)

      if current_str == "\n" then goto loop_end

      elseif current_str == " " then
        table.insert(args, str_buffer)
        str_buffer = ""
      else
        str_buffer = str_buffer .. current_str
      end
      
      ::loop_end::
    end
    return args
  end,

  custom = function (str, s_str)
    local str_buffer = ""
    local args = {}

    for i = 1, #str do
      local current_str = string.sub(str, i, i)

      if current_str == "\n" then goto loop_end

      elseif current_str == s_str then
        table.insert(args, str_buffer)
        str_buffer = ""
      else
        str_buffer = str_buffer .. current_str
      end
      
      ::loop_end::
    end
    return args
  end,

  parse = function (str)
    local str_buffer = ""
    local args = {}

    for i = 1, #str do
      local current_str = string.sub(str, i, i)

      if current_str == "\n" then goto loop_end

      elseif current_str == ";" then
        table.insert(args, str_buffer)
        str_buffer = ""
      else
        str_buffer = str_buffer .. current_str
      end
      
      ::loop_end::
    end
    return args
  end
}


local args
if option == "l" then
  args = hndl.line(str)
  
elseif option == "s" then
  args = hndl.space(str .. " ")

elseif option == "c" then
  args = hndl.custom(str, arg[2])

end

local code
if option ~= "c" then
  code = arg[2]
else
  code = arg[3]
end

local code_args = hndl.parse(code .. ";")

local tokens = {
  print_arg = "print @"
}

for i = 1, #code_args do
  local line = code_args[i]

  if string.match(line, tokens["print_arg"]) == tokens["print_arg"] then
    local arg_number, _ = string.gsub(string.gsub(line, tokens["print_arg"], ""), ";", "")
    arg_number = tonumber(arg_number)

    print(args[arg_number])
  end
end
