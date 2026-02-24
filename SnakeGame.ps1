


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
    }

    [void] update(){
        $this.clear()
    }

}



class Snake{
    $snake_body
    $direction
    [boolean]$mov_pending
    [int] $score
    [System.Collections.Queue]$key

    Snake([int] $x, [int] $y){
        $this.snake_body = @(@(($x-1),$y),@($x,$y))
        $this.direction = ([int]1,[int]0)
        $this.mov_pending = $true
        $this.score = 0
        $this.key = New-Object System.Collections.Queue

    }

    [array]get_head(){
    return $this.snake_body[-1]
    }

    [void]mov([int]$size){
        ## input translation
        $new_head_pos = @(0,0)
        $new_head_pos[0] = (($this.snake_body[-1][0] + $this.direction[0]) % $size)
        $new_head_pos[1] = (($this.snake_body[-1][1] + $this.direction[1]) % $size)
        if ($this.mov_pending){
            [System.Collections.ArrayList]$arrayList = $this.snake_body; $arrayList.RemoveAt(0)
            }
        $this.snake_body += $new_head_pos
        $this.mov_pending = $true

    }

    [void] eat(){
        $this.mov_pending = $false
        $this.score += 1
    
    }


}


class GameEngine{
       [Gameboard] $board
       [Snake] $snake
       [int] $size
       [boolean] $gamestate
       


}

$s = [Snake]::new(5,5)
$s.mov(10)