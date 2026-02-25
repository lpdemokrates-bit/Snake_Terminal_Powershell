


class GameBoard{
    [int] $size
    $grid
    
    
    GameBoard([int] $size){
        $this.size = $size
        $this.grid = @(for($y = 0; $y -lt $size; $y ++){
                        (,@(for($x = 0; $x -lt $size; $x ++){
                            (" ")
                }))
            })
        }

    [void] clear(){
        $this.grid = @(for($y = 0; $y -lt $this.size; $y ++){
                        (,@(for($x = 0; $x -lt $this.size; $x ++){
                            (" ")
                }))
            })
    
    }
    [void] display(){
        [string] $str_hor_u = ""
        [string] $str_hor_d = ""
        for($i = 0; $i -lt (($this.size * 2) -1);$i++ ) {$str_hor_u = $str_hor_u+   "-" } 
        $str_hor_u = "┌" + $str_hor_u + "┐`r`n"
        $str_mid = ""
        for($y = 0; $y -lt $this.size; $y ++){
            $str_mid = $str_mid  + "|" + $this.grid[$y] + "|`r`n"
            }
        for($i = 0; $i -lt (($this.size * 2) -1);$i++ ) {$str_hor_d = $str_hor_d+   "-" } 
        $str_hor_d = "└" + $str_hor_d + "┘`r`n"
        $str_print = $str_hor_u + $str_mid + $str_hor_d
        Write-Host $str_print
        Start-Sleep 1
    }

    [void] update($body){
        $this.clear()
        for($i = 0; $i -lt $body.Count; $i++){
            if($i -eq ($body.Count -1)){
                $this.grid[$body[$i][1]][$body[$i][0]] = "<"
              }
            else{
                $this.grid[$body[$i][1]][$body[$i][0]] = "a"
            
            }

            # FOOD
        
        }
    }

}



class Snake{

    $snake_body
    $direction
    [boolean]$mov_pending
    [int] $score
    [System.Collections.Queue]$key

    Snake([int] $x, [int] $y){
        #$this.snake_body = @(@(($x-1),$y),@($x,$y))
        $this.snake_body =  New-Object System.Collections.ArrayList
        $this.snake_body.Add(@($x,$y))
        $this.snake_body.Add(@(($x-1),$y))
        $this.direction = ([int]1,[int]0)
        $this.mov_pending = $true
        $this.score = 0
        $this.key = New-Object System.Collections.Queue

    }

    [array]get_head(){
    return $this.snake_body[-1]
    }

    [void]mov([int]$size){
        $this.input_trans()
        $new_head_pos = @(0,0)
        $new_head_pos[0] = (($this.snake_body[-1][0] + $this.direction[0]) % $size)
        $new_head_pos[1] = (($this.snake_body[-1][1] + $this.direction[1]) % $size)
        if ($this.mov_pending){
            $this.snake_body.RemoveAt(0)
            }
        $this.snake_body.Add($new_head_pos)
        $this.mov_pending = $true

    }

    [void] eat(){
        $this.mov_pending = $false
        $this.score += 1
    
    }
    [void]handle_input(){
       while ($true){

        if([Console]::KeyAvailable){
         $this.key.Enqueue( [System.Console]::ReadKey($true).Key.ToString())
    }
            }
     }
     
     [void]input_trans(){
        $press = Read-Host 
        switch ($press){
            "w" {$this.direction = (0,-1)}
            "s" {$this.direction = (0,1)}
            "d" {$this.direction = (1,0)}
            "a" {$this.direction = (-1,0)}
                       
        }
        }
        }
     
     






class GameEngine{
       [Gameboard] $board
       [Snake] $snake
       [int] $size
       [boolean] $gamestate
       # Food
       #?init Routine?
       # THREADING

       GameEngine([int] $size){
            $this.board = [Gameboard]::new($size)
            $x = [int] $size / 2
            $y = [int] $size / 2
            $this.snake = [Snake]::new($x,$y)
            $this.size = $size
            $this.gamestate = $true
            
        
               
       
       }

       [void]update_frames(){
            $this.snake.mov($this.size)
            ## Check hit
            $this.board.update($this.snake.snake_body)
            $this.board.display()
       }

       [void]run(){
            while ($this.gamestate){
                $this.update_frames()
            }
            
       }                

}


$game = [GameEngine]::new(10)

$game.run()
