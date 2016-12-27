class Robot
  DIRECTION = ['NORTH', 'EAST', 'SOUTH', 'WEST']

  place: (x, y, f) =>
    @row = parseInt(x)
    @col = parseInt(y)
    if DIRECTION.includes(f)
      @direction = f
    else
      "DIRECTION error. Must be only: #{DIRECTION}"

  move: =>
    @step = @feature_move()
    @row = @step.x
    @col = @step.y

  feature_move: =>
    @maybe_step = { x: @row, y: @col }
    if @direction is 'NORTH'
      @maybe_step.y = @col + 1
    else if @direction is 'EAST'
      @maybe_step.x = @row + 1
    else if @direction is 'SOUTH'
      @maybe_step.y = @col - 1
    else
      @maybe_step.x = @row - 1
    @maybe_step

  left: =>
    @direction = DIRECTION[DIRECTION.indexOf(@direction) - 1] or 'WEST'

  right: =>
    @direction = DIRECTION[DIRECTION.indexOf(@direction) + 1] or 'NORTH'

  report: =>
    {x: @row, y: @col, f: @direction}



class Table

  constructor: (rows = 5, cols = 6) ->
    @max_x = rows - 1
    @max_y = cols - 1
    @min_x = @min_y = 0

  fadein: (x, y) =>
    x >= @min_x and x <= @max_x and y >= @min_y and y <= @max_y

  report: =>
    {x: @max_x, y: @max_y}


class Interface

  constructor: (x = 5, y = 6) ->
    @table = new Table(x, y)
    @robot = new Robot

  place: (x, y, f) =>
    if @table.fadein(x, y) is true
      @robot.place(x, y, f)
    else
      "Error: Position x: #{x} and/or y: #{y} are out of the table. Max x: #{@table.report[x]}, max y: #{@table.report[y]}"

  move: =>
    if robot_placed_on_table(@robot.report())
      new_position = @robot.feature_move()
      if @table.fadein(new_position.x, new_position.y)
        @robot.move()
      else
        'Error: move out of the table'

  left: =>
    @robot.left() if robot_placed_on_table(@robot.report())

  right: =>
    @robot.right() if robot_placed_on_table(@robot.report())

  report: =>
    if robot_placed_on_table(@robot.report())
      report = @robot.report()
      "Robot position #{report.x}, #{report.y}, #{report.f}"
    else
      "Robot out of table"

  robot_placed_on_table = (position)=>
    !(typeof position.x is 'undefined' or typeof position.x is 'null' or typeof position.y is 'undefined' or typeof position.y is 'null')

$ ->
  $('.init-btn').click ->
    table_x = $('.x-table').val()
    table_y = $('.y-table').val()
    place_x = $('.x-place')
    place_y = $('.y-place')
    place_x.attr('max', table_x)
    place_y.attr('max', table_y)
    width = 0
    height = 0
    numberOfCell = 0
    table = $(".table-wrapper")
    cell = $(".table-cell")
    intoContentRow = "<tr class='table-row'></tr>"
    intoContentCell = "<td class='table-cell'></td>"
    robotContent = '<img src="/assets/Robot.png" class="Robot"></p>'
    i = 0
    j = 0
    for i in [0...table_x*table_y]
      while i < table_y
        table.append(intoContentRow)
        i++
      while j < table_x
        $('.table-wrapper').find(".table-row").append(intoContentCell)
        j++
    window.robot1 = new Interface(table_x, table_y)
    $('.place-form').removeClass('disabled hide')
    $('.init-form').hide()
    $('.place-btn').click =>
      x = place_x.val() - 1
      y = place_y.val() - 1
      f = $('.f-place').val()
      if window.robot1.table.fadein(x, y) is true
        robot_place = document.getElementById("myTable").rows[y].cells.item(x)
        $(robot_place).append(robotContent)
        $('.Robot').addClass(f)
        window.robot1.place(x,y,f)
        $('.movement').removeClass('disabled hide')
        $('.place-form').hide()
      else
        window.alert('Select another place')
      $('.left-btn').click =>
        robot_pos = window.robot1.robot.report()
        $('.Robot').removeClass(robot_pos.f)
        window.robot1.right()
        robot_pos = window.robot1.robot.report()
        $('.Robot').addClass(robot_pos.f)
      $('.right-btn').click =>
        robot_pos = window.robot1.robot.report()
        $('.Robot').removeClass(robot_pos.f)
        window.robot1.left()
        robot_pos = window.robot1.robot.report()
        $('.Robot').addClass(robot_pos.f)
      $('.move-btn').click =>
        $('.Robot').remove()
        window.robot1.move()
        robot_pos = window.robot1.robot.report()
        robot_current_place = document.getElementById("myTable").rows[robot_pos.y].cells.item(robot_pos.x)
        $(robot_current_place).append(robotContent)
        $('.Robot').addClass(robot_pos.f)
