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

    [void] update($body, $food){
        $this.clear()
        for($i = 0; $i -lt $body.Count; $i++){
            if($i -eq ($body.Count -1)){
                $this.grid[$body[$i][1]][$body[$i][0]] = "<"
              }
            else{
                $this.grid[$body[$i][1]][$body[$i][0]] = "a"
            
            }

            $this.grid[$food[1]][$food[0]] = "€"
        
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
        $new_head_pos[0] = (($this.snake_body[-1][0] + $size + $this.direction[0]) % $size )
        $new_head_pos[1] = (($this.snake_body[-1][1] + $size + $this.direction[1]) % $size )
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
         $this.input_trans()
    }
            }
     }
     
     [void]input_trans(){
       
        $press = Read-Host
        #$press = $this.key.Dequeue()
        switch ($press){
            "w" {$this.direction = (0,-1)}
            "s" {$this.direction = (0,1)}
            "d" {$this.direction = (1,0)}
            "a" {$this.direction = (-1,0)}
                       }
        }
        }
        
     
     
class Food{
       [array]$pos
       
       Food(){
       $this.pos = @(0,0)
       } 
       
       [void]pos_on_board($size,$body){
            $this.pos = @($this.rand_number($size),$this.rand_number($size))
            while($body -contains $this.pos){
            $this.pos = @($this.rand_number($size),$this.rand_number($size))
            
            }
       }
       [int]rand_number($size){
       $rand = Get-Random -Minimum 0 -Maximum $size
       return $rand
       }

}





class GameEngine{
       [Gameboard] $board
       [Snake] $snake
       [int] $size
       [boolean] $gamestate
       [Food]$food
   
       GameEngine([int] $size){
            $this.board = [Gameboard]::new($size)
            $x = [int] $size / 2
            $y = [int] $size / 2
            $this.snake = [Snake]::new($x,$y)
            $this.size = $size
            $this.gamestate = $true
            $this.food = [Food]::new()
            
        
               
       
       }

       [void]update_frames(){
            $this.snake.mov($this.size)
            $this.check_hit()
            $this.board.update($this.snake.snake_body,$this.food.pos)
            $this.board.display()
       }

       [void]check_hit(){
            if($this.snake.get_head()[0] -eq $this.food.pos[0] -and $this.snake.get_head()[1] -eq $this.food.pos[1]){
                $this.snake.eat()
                $this.food.pos_on_board($this.size,$this.snake.snake_body)
            }
        }
       [void]run(){
            while ($this.gamestate){
                $this.update_frames()
            }
            
       }                

}


$game = [GameEngine]::new(10)

$game.run()


