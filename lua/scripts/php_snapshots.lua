local M = {}

-- Function to find test method signature in current or previous lines
local function find_test_method(bufnr, current_line, lookback_lines)
  lookback_lines = lookback_lines or 10
  local start_line = math.max(0, current_line - lookback_lines)

  for line_num = current_line, start_line, -1 do
    local line = vim.api.nvim_buf_get_lines(bufnr, line_num, line_num + 1, false)[1]
    if line then
      -- Match PHPUnit test method signature
      local method_name = line:match("public%s+function%s+(test%w+)")
      if method_name then
        return method_name
      end
    end
  end

  return nil
end

-- Function to extract path and filename from buffer path
local function parse_buffer_path(buffer_path)
  -- Get the directory path and filename separately
  local dir = vim.fn.fnamemodify(buffer_path, ":h")
  local filename = vim.fn.fnamemodify(buffer_path, ":t:r") -- filename without extension

  return dir, filename
end

-- Function to find snapshot files matching the pattern
local function find_snapshot_files(snapshot_dir, filename, method_name)
  local pattern = string.format("%s__%s__*.json", filename, method_name)
  local search_path = vim.fn.glob(snapshot_dir .. "/" .. pattern, false, true)

  return search_path
end

-- Main function to open snapshots
function M.open_snapshots_for_current_test(lookback_lines)
  lookback_lines = lookback_lines or 10

  local bufnr = vim.api.nvim_get_current_buf()
  local buffer_path = vim.api.nvim_buf_get_name(bufnr)

  -- Get current cursor position (line is 0-indexed in API)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor_pos[1] - 1

  -- Find test method signature
  local method_name = find_test_method(bufnr, current_line, lookback_lines)

  if not method_name then
    print("No test method signature found in the current or previous " .. lookback_lines .. " lines")
    return
  end

  -- Parse buffer path
  local dir, filename = parse_buffer_path(buffer_path)
  local snapshot_dir = dir .. "/__snapshots__"

  -- Check if snapshot directory exists
  if vim.fn.isdirectory(snapshot_dir) == 0 then
    print("Snapshot directory not found: " .. snapshot_dir)
    return
  end

  -- Find matching snapshot files
  local snapshot_files = find_snapshot_files(snapshot_dir, filename, method_name)

  if #snapshot_files == 0 then
    print(string.format("No snapshots found for %s::%s", filename, method_name))
    return
  end

  -- Save the original window and cursor position
  local original_win = vim.api.nvim_get_current_win()
  local original_cursor = vim.api.nvim_win_get_cursor(original_win)

  -- Open each snapshot file in a new tab
  for _, file in ipairs(snapshot_files) do
    vim.cmd("tabnew " .. vim.fn.fnameescape(file))
  end

  -- Return to the original window and restore cursor position
  vim.api.nvim_set_current_win(original_win)
  vim.api.nvim_win_set_cursor(original_win, original_cursor)

  print(string.format("Opened %d snapshot(s) for %s::%s", #snapshot_files, filename, method_name))
end

return M
