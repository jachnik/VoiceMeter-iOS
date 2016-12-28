import UIKit
import AVFoundation
import Charts
import Alamofire
import Realm

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    let buttonStartText : String = "Start recording"
    let buttonEndText : String = "Stop recording"
    
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var recordingButton: UIButton!
    var data : [ChartDataEntry] = []
    var pos : Int = 0
    var chartDataSet: LineChartDataSet = LineChartDataSet()
    var voiceMeterService = VoiceMeterService()
    var timer : Timer?
    
    @IBAction func recordingButtonClicked(_ sender: Any) {
        if !voiceMeterService.isRecording {
            voiceMeterService.startRecording()
            voiceMeterService.isRecording = true
            recordingButton.setTitle(buttonEndText, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 0.025, target: self, selector: #selector(sampleRecordAndUpdateValue), userInfo: nil, repeats: true)
        } else {
            voiceMeterService.finishRecording(success: true)
            voiceMeterService.isRecording = false
            timer?.invalidate()
            timer = nil
            recordingButton.setTitle(buttonStartText, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingButton.setTitle(buttonStartText, for: .normal)
        setupChart()
    }
    
    func sampleRecordAndUpdateValue(){
        let avgInDbs = voiceMeterService.sampleRecord()
        let event = Event(deviceIdentifier: (UIDevice.current.identifierForVendor?.uuidString)!, voicePower: Int32(avgInDbs))
        let eventService: EventService = EventService()
        _ = eventService.post(obj: event)
        updateChart(voicePower: Double(event.voicePower))
        print(DateTimeHelper.getTime() + "|\(event.voicePower)")
    }
    
    func updateChart(voicePower : Double) {
        pos = pos + 1
        _ = chartDataSet.removeFirst()
        _ = chartDataSet.addEntry(ChartDataEntry(x: Double(pos), y: voicePower, data: voicePower as AnyObject?))
        chartDataSet.notifyDataSetChanged()
        lineChart.data?.notifyDataChanged()
        lineChart.notifyDataSetChanged()
    }
    
    func setupChart(){
        initData()
        lineChart.setYAxisMaxWidth(.left, width: 160.0)
        lineChart.setYAxisMaxWidth(.right, width: 160.0)
        lineChart.setYAxisMinWidth(.left, width: 0.0)
        lineChart.setYAxisMinWidth(.right, width: 0.0)
    }
    
    func initData(){
        pos = 150;
        for i in 1...pos {
            let entry = ChartDataEntry(x: Double(i), y: 0.0, data: 0.0 as AnyObject?)
            data.append(entry)
        }
        chartDataSet = LineChartDataSet(values: data, label: "#")
        chartDataSet.colors.removeAll()
        chartDataSet.colors.append(.red)
        chartDataSet.visible = true
        chartDataSet.drawValuesEnabled = false
        chartDataSet.drawCirclesEnabled = false
        let chartData = LineChartData(dataSet: chartDataSet)
        lineChart.data = chartData
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
