
LevelManager = class('LevelManager')

function LevelManager:initialize()

end

function LevelManager:setupLevel (level)
  for i,row in ipairs(level) do
    for j,blocktype in ipairs(row) do
      if blocktype > 0 then
        local block = Block(100 * j, 50 + 35 * i, blocktype)
        table.insert(blocks, block)
      end
    end
  end
end
