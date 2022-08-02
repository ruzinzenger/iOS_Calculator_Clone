//
//  ViewController.swift
//  iOS_Calculator
//
//  Created by Ruzin Zenger on 7/19/22.
//

import UIKit

class ViewController: UIViewController {

    // user interaction enabled
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBOutlet weak var acButton: UIButton!
    
    @IBOutlet weak var divButton: UIButton!
    
    
    @IBOutlet weak var mulButton: UIButton!
    
    
    @IBOutlet weak var subButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    // numbers in this array should be convertable to Double (no commas)
    var expression : [String] = []
    
    // if last operation performed was 'equals'
    // if that is the case, and a number is clicked, the new number replaces the current number in the label
    var equals_done : Bool = false
    
    // if last clicked button was an operation of some kind, then clicking a number
    // will reset the output label
    var operation_clicked_last : Bool = false
    
    var percent_clicked_last : Bool = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        outputLabel.text = "0"
        print("start")
        //print(Double("-2.0")! * 2.0)
        
        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizerRight.direction = .right
        
        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizerRight.direction = .left
        
        outputLabel.addGestureRecognizer(swipeGestureRecognizerRight)
        outputLabel.addGestureRecognizer(swipeGestureRecognizerLeft)
        
        
        print(format_result(s: "9123456"))
        
        print(890.0 - 890.0)
        
    }
    
    
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        if let cur = outputLabel.text{
            if cur == "0"{
                return
            }
            if cur.count == 1 || cur == "-0"{
                outputLabel.text = "0"
            }else if cur.count == 2 && cur.first == "-"{
                outputLabel.text = "-0"
            }else{
                if num_decimals(lbl: cur) != 0{
                    outputLabel.text = String(cur.dropLast())
                }else{

                    var s : String = String(cur.dropLast())


                    
                    s = format_result(s: String(doublify_input(s: s)))

                    outputLabel.text = s
                }
                
            }
            
            
        }
        
    }

    
    @IBAction func acButtonClick(_ sender: Any) {
        // todo
        
    }
    
    
    @IBAction func signButton(_ sender: Any) {
        var current : String = outputLabel.text!
        if current.first == "-"{
            current.remove(at: current.firstIndex(of: "-")!)
            outputLabel.text = current
        }else{
            outputLabel.text = "-" + current
        }
        
    }
    
    // TODO
    @IBAction func percentButton(_ sender: Any) {
        if var input_num = Double(outputLabel.text!){
            input_num /= 100
            outputLabel.text = String(input_num)
        }
        
        percent_clicked_last = true
        
    }
    
    
    @IBAction func divisionButton(_ sender: Any) {
        operators_color_change(id: 0)
        
        operator_clicked()
        
        expression.append("/")
        
        equals_done = false
        operation_clicked_last = true
        percent_clicked_last = false
        
    }
    
    
    @IBAction func multiplicationButton(_ sender: Any) {
        operators_color_change(id: 1)
        
        operator_clicked()
        
        expression.append("*")
        
        
        equals_done = false
        operation_clicked_last = true
        percent_clicked_last = false
    }
    
    
    @IBAction func subtractionButton(_ sender: Any) {
        operators_color_change(id: 2)
        
        operator_clicked()
        
        expression.append("-")
        
        
        equals_done = false
        operation_clicked_last = true
        percent_clicked_last = false
    }
    
    @IBAction func additionButton(_ sender: Any) {
        operators_color_change(id: 3)
        
        operator_clicked()
        
        expression.append("+")
        
        equals_done = false
        operation_clicked_last = true
        percent_clicked_last = false
    }
    
    @IBAction func equalsButton(_ sender: Any) {
        operators_color_change(id: 4)
        
        // todo
        
        equals_done = true
        operation_clicked_last = false
        percent_clicked_last = false
    }
    
    
    
    
    @IBAction func decimalButton(_ sender: Any) {
        if equals_done || operation_clicked_last{
            outputLabel.text = "0."
        }else{
            let cur : String = outputLabel.text!
            if count_digits(num: cur) >= 9{
                return
            }
            if num_decimals(lbl: cur) == 0{
                outputLabel.text = cur + "."
            }
            
        }
        
        equals_done = false
        operation_clicked_last = false
        percent_clicked_last = false
    }
    
    
    @IBAction func zeroButton(_ sender: Any) {
        if outputLabel.text == "0" || outputLabel.text == "-0"{
            return
        }
        
        number_click(digit: "0")
        
    }
    
    @IBAction func oneButton(_ sender: Any) {
        number_click(digit: "1")
    }
    
    
    @IBAction func twoButton(_ sender: Any) {
        number_click(digit: "2")
    }
    
    
    @IBAction func threeButton(_ sender: Any) {
        number_click(digit: "3")
    }
    
    
    @IBAction func fourButton(_ sender: Any) {
        number_click(digit: "4")
    }
    
    
    @IBAction func fiveButton(_ sender: Any) {
        number_click(digit: "5")
    }
    
    
    @IBAction func sixButton(_ sender: Any) {
        number_click(digit: "6")
    }
    
    
    @IBAction func sevenButton(_ sender: Any) {
        number_click(digit: "7")
    }
    
    
    @IBAction func eightButton(_ sender: Any) {
        number_click(digit: "8")
    }
    
    
    @IBAction func nineButton(_ sender: Any) {
        number_click(digit: "9")
    }
    
    
    // --------------------------- HELPER FUNCTIONS ------------------------------
    
    // helper function for operations that are commonly performed when a button
    // representing a non zero digit is clicked by user
    func number_click(digit : String){
        operators_color_change(id: 4)
        
        // special cases
        if outputLabel.text! == "0"{
            outputLabel.text! = digit
            return
        }else if outputLabel.text! == "-0"{
            outputLabel.text = "-" + digit
            return
        }
        
        
        if equals_done || operation_clicked_last || percent_clicked_last{
            outputLabel.text = digit
            print(equals_done)
            print(operation_clicked_last)
            print(percent_clicked_last)
            
        }else{
            
            if(count_digits(num: outputLabel.text!) >= 9){
                // input can not have more than 9 digits
                return
            }
            
            var current : String = outputLabel.text!
            print("1: \(current)")
            current += digit
            print("2: \(current)")
            print("3: \(String(doublify_input(s: current)))")
            current = format_result(s: String(doublify_input(s: current)))
            print("4: \(current)")
            
            outputLabel.text! = current
        }
        
        equals_done = false
        operation_clicked_last = false
        
    }
    
    // helper function to find the number of decimal points in an input string
    func num_decimals(lbl : String) -> Int {
        var num_dec : Int = 0
        
        for ch in lbl{
            if ch == "."{
                num_dec += 1
            }
        }
        
        return num_dec
    }
    
    
    // helper function that determines whether a string's length would fit the
    // label length criteria
    func count_digits(num : String) -> Int{
        if num.count == 0{
            return 0
        }
        
        var num_digits : Int = 0
        
        for ch in num{
            if ch != "," && ch != "." && ch != "-"{
                num_digits += 1
            }
        }
        
        return num_digits
        

        
    }

    
    
    // id values: Division = 0, Multiplication = 1, Subtraction = 2, Addition = 3, Equals = 4
    func operators_color_change(id : Int){
        switch id {
        case 0:
            divButton.backgroundColor = UIColor.white
            divButton.setTitleColor(UIColor(named: "orangeButton"), for: UIControl.State.normal)
            
            mulButton.backgroundColor = UIColor(named: "orangeButton")
            mulButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            subButton.backgroundColor = UIColor(named: "orangeButton")
            subButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            addButton.backgroundColor = UIColor(named: "orangeButton")
            addButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            
        case 1:
            divButton.backgroundColor = UIColor(named: "orangeButton")
            divButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            mulButton.backgroundColor = UIColor.white
            mulButton.setTitleColor(UIColor(named: "orangeButton"), for: UIControl.State.normal)
            
            subButton.backgroundColor = UIColor(named: "orangeButton")
            subButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            addButton.backgroundColor = UIColor(named: "orangeButton")
            addButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        case 2:
            divButton.backgroundColor = UIColor(named: "orangeButton")
            divButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            mulButton.backgroundColor = UIColor(named: "orangeButton")
            mulButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            subButton.backgroundColor = UIColor.white
            subButton.setTitleColor(UIColor(named: "orangeButton"), for: UIControl.State.normal)
            
            addButton.backgroundColor = UIColor(named: "orangeButton")
            addButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        case 3:
            divButton.backgroundColor = UIColor(named: "orangeButton")
            divButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            mulButton.backgroundColor = UIColor(named: "orangeButton")
            mulButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            subButton.backgroundColor = UIColor(named: "orangeButton")
            subButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            addButton.backgroundColor = UIColor.white
            addButton.setTitleColor(UIColor(named: "orangeButton"), for: UIControl.State.normal)
        case 4:
            divButton.backgroundColor = UIColor(named: "orangeButton")
            divButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            mulButton.backgroundColor = UIColor(named: "orangeButton")
            mulButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            subButton.backgroundColor = UIColor(named: "orangeButton")
            subButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            addButton.backgroundColor = UIColor(named: "orangeButton")
            addButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
        default:
            return
        }
        
    }
    
    

    // turns the current input in the label into a real calculator friendly format
    // of type Double
    // takes care of misplaced "." at the end of the input if there is one
    // takes care of commas
    func doublify_input(s : String) -> Double{
        var cur = s
        if cur.last == "."{
            cur.removeLast()
        }
        
        var cur_no_commas = ""
        
        for ch in cur{
            if ch != ","{
                cur_no_commas += String(ch)
            }
        }
        
        if let converted = Double(cur_no_commas){
            return converted
        }else{
            return 0.0
        }
    }
    
    
    // evaluates the current expression array and returns the result as a String
    // the reason for String type return is that the result can also be an error message
    // it is important to notice that even though the return type is String, this output
    // is not ready for display (it has to be formatted), it is just a String version of
    // the raw Double result
    func evaluate() -> String{
        if(expression.count == 1){
            return expression[0]
        }
        
        // multiplications
        
        var temp : [String] = expression
        
        var size = temp.count
        
        for i in 0...size-1{
            if temp[i] == "*"{
                assert(i != 0 && i != size-1)
                
                let first : Double = Double(temp[i-1])!
                let second : Double = Double(temp[i+1])!
                
                temp[i+1] = String(first * second)
                temp[i] = "N"
                temp[i-1] = "N"
            }
        }
        
        var temp2 : [String] = []
        
        for i in 0...size-1{
            if temp[i] != "N"{
                temp2.append(temp[i])
            }
        }
        
        // divisions
        
        size = temp2.count
        
        
        for i in 0...size-1{
            if temp2[i] == "/"{
                assert(i != 0 && i != size-1)
                
                let first : Double = Double(temp2[i-1])!
                let second : Double = Double(temp2[i+1])!
                
                if second == 0.0{
                    return "Error"
                }
                temp2[i+1] = String(first / second)
                temp2[i] = "N"
                temp2[i-1] = "N"
            }
        }
        
        var temp3 : [String] = []
        
        for i in 0...size-1{
            if temp2[i] != "N"{
                temp3.append(temp2[i])
            }
        }
        
        
        // subtractions
        
        size = temp3.count

        
        for i in 0...size-1{
            if temp3[i] == "-"{
                assert(i != 0 && i != size-1)
                
                let first : Double = Double(temp3[i-1])!
                let second : Double = Double(temp3[i+1])!
                
                temp3[i+1] = String(first - second)
                temp3[i] = "N"
                temp3[i-1] = "N"
            }
        }
        
        var temp4 : [String] = []
        
        for i in 0...size-1{
            if temp3[i] != "N"{
                temp4.append(temp3[i])
            }
        }
        
        
        // additions
        
        size = temp4.count
        
        var res : Double = 0.0
        
        for i in 0...size-1{
            if temp4[i] != "+"{
                res += Double(temp4[i])!
            }
        }
        
        
        return String(res)
    }
    
    
    func format_result(s : String) -> String{
        print("here: \(s)")
        var s = s
        // remove .0 at the end if it's present
        if s.suffix(2) == ".0"{
            s.removeLast()
            s.removeLast()
        }
        
        
        if count_digits(num: s) > 9{
            let num : Double = Double(s)!
            // truncation needed
            if num_decimals(lbl: s) == 0{
                // very large number
                // TODO
                return s
            }else{
                // small number with a lot of decimal places
                let rounded : Double = Double(round(100000000000 * num) / 100000000000)
                return String(rounded)
            }
            
        }else{
            // add commas if needed
            var s_commas : String = ""
            
            let is_neg : Bool = s.first == "-"
            
            if is_neg{
                s.removeFirst()
            }
            
            var decimal_found : Bool = false
            var decimal_places_counter : Int = 0
            
            for ch in s.reversed(){
                s_commas = String(ch) + s_commas
                
                if ch == "."{
                    decimal_found = true
                }
                
                if ch != "-" && ch != "."{
                    decimal_places_counter += 1
                }
                    
                if !decimal_found && decimal_places_counter == 3{
                    s_commas = "," + s_commas
                    decimal_places_counter = 0
                }
                
            }
            
            if s_commas.first == ","{
                s_commas.removeFirst()
            }
            
            if is_neg{
                s_commas = "-" + s_commas
            }
            
            return s_commas
        }
    }
    
    
    
    func operator_clicked(){
        
        if operation_clicked_last{
            // user changed their mind about the current operation
            expression.removeLast()
        }else{
            
            let latest_input : Double = doublify_input(s: outputLabel.text!)
            expression.append(String(latest_input))
        }
        
        // calculate the result of the current expression (doesn't include our current operator since the next value for that hasn't been entered yet)
        // the display has to change to reflect the result of the expression so far
        let current_result : String = evaluate()
        
        // if the current expression results in an error, wipe it clean and exit
        if current_result == "Error"{
            outputLabel.text = "Error"
            expression = []
            return
        }
        
        let current_result_formatted : String = format_result(s : current_result)
        outputLabel.text = current_result_formatted
        
    }
}

