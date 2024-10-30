import UIKit
import SwiftUI
import Charts

struct VariableDataPoint: Codable {
    let value: Double
    let date: Date
    let time: String
}

struct VariableData: Codable {
    let variable: String
    let data: [VariableDataPoint]
}

class GraphsViewController: UIViewController {

    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var chartTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var variables: UIButton!

    var MonterreyTemperatureVariables = [Temperature]()
    var MonterreyHumidityVariables = [Humidity]()
    var MonterreySoundVariables = [Sound]()

    var GuadalajaraTemperatureVariables = [Temperature]()
    var GuadalajaraHumidityVariables = [Humidity]()
    var GuadalajaraSoundVariables = [Sound]()

    var MexicoCityTemperatureVariables = [Temperature]()
    var MexicoCityHumidityVariables = [Humidity]()
    var MexicoCitySoundVariables = [Sound]()

    var TorontoTemperatureVariables = [Temperature]()
    var TorontoHumidityVariables = [Humidity]()
    var TorontoSoundVariables = [Sound]()
    
    var timer: Timer?

    var selectedTimeRange: String = "Last 24 hours"
    var selectedChartType: String = "Line"

    var selectedVariableTypes: Set<String> = ["Monterrey Temperature"]

    var chartView: UIHostingController<CustomChartView>?

    var loadedVariableData: [VariableData] = []
    
    var isInitialZeroRemoved = false

    override func viewDidLoad() {
        super.viewDidLoad()

        loadVariables()
        
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fetchVariables), userInfo: nil, repeats: true)

        periodSegmentedControl.selectedSegmentIndex = 0
        chartTypeSegmentedControl.selectedSegmentIndex = 0

        updateLoadedVariableData()
        setupChart()

        periodSegmentedControl.addTarget(self, action: #selector(timeRangeChanged), for: .valueChanged)
        chartTypeSegmentedControl.addTarget(self, action: #selector(chartTypeChanged), for: .valueChanged)

        NotificationCenter.default.addObserver(self, selector: #selector(variablesSelected(_:)), name: Notification.Name("VariablesSelected"), object: nil)
    }

    func loadVariables() {
        MonterreyTemperatureVariables.append(Temperature(value: "0", timeStamp: Date()))
        MonterreyHumidityVariables.append(Humidity(value: "0", timeStamp: Date()))
        MonterreySoundVariables.append(Sound(value: "0", timeStamp: Date()))

        GuadalajaraTemperatureVariables.append(Temperature(value: "0", timeStamp: Date()))
        GuadalajaraHumidityVariables.append(Humidity(value: "0", timeStamp: Date()))
        GuadalajaraSoundVariables.append(Sound(value: "0", timeStamp: Date()))

        MexicoCityTemperatureVariables.append(Temperature(value: "0", timeStamp: Date()))
        MexicoCityHumidityVariables.append(Humidity(value: "0", timeStamp: Date()))
        MexicoCitySoundVariables.append(Sound(value: "0", timeStamp: Date()))

        TorontoTemperatureVariables.append(Temperature(value: "0", timeStamp: Date()))
        TorontoHumidityVariables.append(Humidity(value: "0", timeStamp: Date()))
        TorontoSoundVariables.append(Sound(value: "0", timeStamp: Date()))
    }

    @objc func fetchVariables() {
        
        guard let MonterreyTemperatureUrl = URL(string: "http://localhost:8765/Monterrey/Temperature") else { return }
        guard let MonterreyHumidityUrl = URL(string: "http://localhost:8765/Monterrey/Humidity") else { return }
        guard let MonterreySoundUrl = URL(string: "http://localhost:8765/Monterrey/Sound") else { return }
        
        guard let GuadalajaraTemperatureUrl = URL(string: "http://localhost:8765/Guadalajara/Temperature") else { return }
        guard let GuadalajaraHumidityUrl = URL(string: "http://localhost:8765/Guadalajara/Humidity") else { return }
        guard let GuadalajaraSoundUrl = URL(string: "http://localhost:8765/Guadalajara/Sound") else { return }
        
        guard let MexicoCityTemperatureUrl = URL(string: "http://localhost:8765/CDMX/Temperature") else { return }
        guard let MexicoCityHumidityUrl = URL(string: "http://localhost:8765/CDMX/Humidity") else { return }
        guard let MexicoCitySoundUrl = URL(string: "http://localhost:8765/CDMX/Sound") else { return }
        
        guard let TorontoTemperatureUrl = URL(string: "http://localhost:8765/Toronto/Temperature") else { return }
        guard let TorontoHumidityUrl = URL(string: "http://localhost:8765/Toronto/Humidity") else { return }
        guard let TorontoSoundUrl = URL(string: "http://localhost:8765/Toronto/Sound") else { return }
        
        
        let MonterreyTemperatureTask = URLSession.shared.dataTask(with: MonterreyTemperatureUrl) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            do {
                
                let temperaturePT = try? JSONDecoder().decode(TemperaturePT.self, from: data)
                
                let temperature = Temperature(value: String(temperaturePT!.temperature), timeStamp: Date())
                
                DispatchQueue.main.async {
                    self.MonterreyTemperatureVariables.append(temperature)
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }
        
        let MonterreyHumidityTask = URLSession.shared.dataTask(with: MonterreyHumidityUrl) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            do {
                
                let humidityPT = try? JSONDecoder().decode(HumidityPT.self, from: data)
                
                let humidity = Humidity(value: String(humidityPT!.humidity), timeStamp: Date())
                
                DispatchQueue.main.async {
                    self.MonterreyHumidityVariables.append(humidity)
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }
        
        let MonterreySoundTask = URLSession.shared.dataTask(with: MonterreySoundUrl) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            do {
                
                let soundPT = try? JSONDecoder().decode(SoundPT.self, from: data)
                
                let sound = Sound(value: String(soundPT!.sound), timeStamp: Date())
                
                DispatchQueue.main.async {
                    self.MonterreySoundVariables.append(sound)
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }
        
        let GuadalajaraTemperatureTask = URLSession.shared.dataTask(with: GuadalajaraTemperatureUrl) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            do {
                
                let temperaturePT = try? JSONDecoder().decode(TemperaturePT.self, from: data)
                
                let temperature = Temperature(value: String(temperaturePT!.temperature), timeStamp: Date())
                
                DispatchQueue.main.async {
                    self.GuadalajaraTemperatureVariables.append(temperature)
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }
        
        let GuadalajaraHumidityTask = URLSession.shared.dataTask(with: GuadalajaraHumidityUrl) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            do {
                
                let humidityPT = try? JSONDecoder().decode(HumidityPT.self, from: data)
                
                let humidity = Humidity(value: String(humidityPT!.humidity), timeStamp: Date())
                
                DispatchQueue.main.async {
                    self.GuadalajaraHumidityVariables.append(humidity)
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }
        
        let GuadalajaraSoundTask = URLSession.shared.dataTask(with: GuadalajaraSoundUrl) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            do {
                
                let soundPT = try? JSONDecoder().decode(SoundPT.self, from: data)
                
                let sound = Sound(value: String(soundPT!.sound), timeStamp: Date())
                
                DispatchQueue.main.async {
                    self.GuadalajaraSoundVariables.append(sound)
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }
        
        let MexicoCityTemperatureTask = URLSession.shared.dataTask(with: MexicoCityTemperatureUrl) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            do {
                
                let temperaturePT = try? JSONDecoder().decode(TemperaturePT.self, from: data)
                
                let temperature = Temperature(value: String(temperaturePT!.temperature), timeStamp: Date())
                
                DispatchQueue.main.async {
                    self.MexicoCityTemperatureVariables.append(temperature)
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }
        
        let MexicoCityHumidityTask = URLSession.shared.dataTask(with: MexicoCityHumidityUrl) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            do {
                
                let humidityPT = try? JSONDecoder().decode(HumidityPT.self, from: data)
                
                let humidity = Humidity(value: String(humidityPT!.humidity), timeStamp: Date())
                
                DispatchQueue.main.async {
                    self.MexicoCityHumidityVariables.append(humidity)
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }
        
        let MexicoCitySoundTask = URLSession.shared.dataTask(with: MexicoCitySoundUrl) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            do {
                
                let soundPT = try? JSONDecoder().decode(SoundPT.self, from: data)
                
                let sound = Sound(value: String(soundPT!.sound), timeStamp: Date())
                
                DispatchQueue.main.async {
                    self.MexicoCitySoundVariables.append(sound)
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }
        
        let TorontoTemperatureTask = URLSession.shared.dataTask(with: TorontoTemperatureUrl) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            do {
                
                let temperaturePT = try? JSONDecoder().decode(TemperaturePT.self, from: data)
                
                let temperature = Temperature(value: String(temperaturePT!.temperature), timeStamp: Date())
                
                DispatchQueue.main.async {
                    self.TorontoTemperatureVariables.append(temperature)
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }
        
        let TorontoHumidityTask = URLSession.shared.dataTask(with: TorontoHumidityUrl) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            do {
                
                let humidityPT = try? JSONDecoder().decode(HumidityPT.self, from: data)
                
                let humidity = Humidity(value: String(humidityPT!.humidity), timeStamp: Date())
                
                DispatchQueue.main.async {
                    self.TorontoHumidityVariables.append(humidity)
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }
        
        let TorontoSoundTask = URLSession.shared.dataTask(with: TorontoSoundUrl) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            do {
                
                let soundPT = try? JSONDecoder().decode(SoundPT.self, from: data)
                
                let sound = Sound(value: String(soundPT!.sound), timeStamp: Date())
                
                DispatchQueue.main.async {
                    self.TorontoSoundVariables.append(sound)
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }
        
        MonterreyTemperatureTask.resume()
        MonterreyHumidityTask.resume()
        MonterreySoundTask.resume()
        
        GuadalajaraTemperatureTask.resume()
        GuadalajaraHumidityTask.resume()
        GuadalajaraSoundTask.resume()
        
        MexicoCityTemperatureTask.resume()
        MexicoCityHumidityTask.resume()
        MexicoCitySoundTask.resume()
        
        TorontoTemperatureTask.resume()
        TorontoHumidityTask.resume()
        TorontoSoundTask.resume()
        
        if !self.isInitialZeroRemoved {
            self.MonterreyTemperatureVariables.removeFirst()
            self.MonterreyHumidityVariables.removeFirst()
            self.MonterreySoundVariables.removeFirst()
            self.GuadalajaraTemperatureVariables.removeFirst()
            self.GuadalajaraHumidityVariables.removeFirst()
            self.GuadalajaraSoundVariables.removeFirst()
            self.MexicoCityTemperatureVariables.removeFirst()
            self.MexicoCityHumidityVariables.removeFirst()
            self.MexicoCitySoundVariables.removeFirst()
            self.TorontoTemperatureVariables.removeFirst()
            self.TorontoHumidityVariables.removeFirst()
            self.TorontoSoundVariables.removeFirst()
            self.isInitialZeroRemoved = true
        }
        
        self.updateLoadedVariableData()
        self.setupChart()
    }
    
    func updateLoadedVariableData() {
        loadedVariableData = [
            VariableData(variable: "Monterrey Temperature", data: MonterreyTemperatureVariables.map { VariableDataPoint(value: Double($0.value) ?? 0, date: $0.timeStamp, time: formatDate($0.timeStamp)) }),
            VariableData(variable: "Monterrey Humidity", data: MonterreyHumidityVariables.map { VariableDataPoint(value: Double($0.value) ?? 0, date: $0.timeStamp, time: formatDate($0.timeStamp)) }),
            VariableData(variable: "Monterrey Sound", data: MonterreySoundVariables.map { VariableDataPoint(value: Double($0.value) ?? 0, date: $0.timeStamp, time: formatDate($0.timeStamp)) }),
            VariableData(variable: "Guadalajara Temperature", data: GuadalajaraTemperatureVariables.map { VariableDataPoint(value: Double($0.value) ?? 0, date: $0.timeStamp, time: formatDate($0.timeStamp)) }),
            VariableData(variable: "Guadalajara Humidity", data: GuadalajaraHumidityVariables.map { VariableDataPoint(value: Double($0.value) ?? 0, date: $0.timeStamp, time: formatDate($0.timeStamp)) }),
            VariableData(variable: "Guadalajara Sound", data: GuadalajaraSoundVariables.map { VariableDataPoint(value: Double($0.value) ?? 0, date: $0.timeStamp, time: formatDate($0.timeStamp)) }),
            VariableData(variable: "Mexico City Temperature", data: MexicoCityTemperatureVariables.map { VariableDataPoint(value: Double($0.value) ?? 0, date: $0.timeStamp, time: formatDate($0.timeStamp)) }),
            VariableData(variable: "Mexico City Humidity", data: MexicoCityHumidityVariables.map { VariableDataPoint(value: Double($0.value) ?? 0, date: $0.timeStamp, time: formatDate($0.timeStamp)) }),
            VariableData(variable: "Mexico City Sound", data: MexicoCitySoundVariables.map { VariableDataPoint(value: Double($0.value) ?? 0, date: $0.timeStamp, time: formatDate($0.timeStamp)) }),
            VariableData(variable: "Toronto Temperature", data: TorontoTemperatureVariables.map { VariableDataPoint(value: Double($0.value) ?? 0, date: $0.timeStamp, time: formatDate($0.timeStamp)) }),
            VariableData(variable: "Toronto Humidity", data: TorontoHumidityVariables.map { VariableDataPoint(value: Double($0.value) ?? 0, date: $0.timeStamp, time: formatDate($0.timeStamp)) }),
            VariableData(variable: "Toronto Sound", data: TorontoSoundVariables.map { VariableDataPoint(value: Double($0.value) ?? 0, date: $0.timeStamp, time: formatDate($0.timeStamp)) }),
        ]
    }

    @objc func timeRangeChanged() {
        selectedTimeRange = periodSegmentedControl.titleForSegment(at: periodSegmentedControl.selectedSegmentIndex) ?? "Last 24 hours"
        setupChart()
    }

    @objc func chartTypeChanged() {
        selectedChartType = chartTypeSegmentedControl.titleForSegment(at: chartTypeSegmentedControl.selectedSegmentIndex) ?? "Line"
        setupChart()
    }

    @objc func variablesSelected(_ notification: Notification) {
        if let selected = notification.object as? Set<String> {
            selectedVariableTypes = selected
            setupChart()
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter.string(from: date)
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    
    func setupChart() {
        let filteredData = loadedVariableData.filter { selectedVariableTypes.contains($0.variable) }

        let chartView = CustomChartView(
            timeRange: .constant(selectedTimeRange),
            chartType: .constant(selectedChartType),
            variableData: filteredData,
            isLast24Hours: selectedTimeRange == "Last 24 hours"
        )

        let hostingController = UIHostingController(rootView: chartView)
        
        if let existingChartView = self.chartView {
            existingChartView.view.removeFromSuperview()
            existingChartView.removeFromParent()
        }

        self.chartView = hostingController

        addChild(hostingController)
        graphView.addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: graphView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: graphView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: graphView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: graphView.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }

    @IBAction func variablesButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "VariablesViewController") as? VariablesViewController {

            let allVariableNames: Set<String> = [
                "Monterrey Temperature", "Monterrey Humidity", "Monterrey Sound",
                "Guadalajara Temperature", "Guadalajara Humidity", "Guadalajara Sound",
                "Mexico City Temperature", "Mexico City Humidity", "Mexico City Sound",
                "Toronto Temperature", "Toronto Humidity", "Toronto Sound"
            ]

            vc.selectedVariables = self.selectedVariableTypes
            vc.allVariableNames = allVariableNames

            present(vc, animated: true, completion: nil)
        }
    }

    struct CustomChartView: View {
        @Binding var timeRange: String
        @Binding var chartType: String

        let variableData: [VariableData]
        let isLast24Hours: Bool

        var body: some View {
            VStack {
                if chartType == "Line" {
                    LineChart(variableData: variableData, isLast24Hours: isLast24Hours)
                        .frame(height: 300)
                } else if chartType == "Bar" {
                    BarChart(variableData: variableData, isLast24Hours: isLast24Hours)
                        .frame(height: 300)
                }
            }
        }
    }

    struct LineChart: View {
        let variableData: [VariableData]
        let isLast24Hours: Bool

        var body: some View {
            Chart {
                ForEach(variableData, id: \.variable) { series in
                    ForEach(series.data, id: \.date) { item in
                        LineMark(
                            x: .value("Time", isLast24Hours ? formatTime(item.date) : formatDate(item.date)),
                            y: .value("Value", item.value)
                        )
                    }
                    .foregroundStyle(by: .value("Variable", series.variable))
                }
            }
        }

        func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM"
            return formatter.string(from: date)
        }

        func formatTime(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            return formatter.string(from: date)
        }
    }

    struct BarChart: View {
        let variableData: [VariableData]
        let isLast24Hours: Bool

        var body: some View {
            Chart {
                ForEach(variableData, id: \.variable) { series in
                    ForEach(series.data, id: \.date) { item in
                        BarMark(
                            x: .value("Time", isLast24Hours ? formatTime(item.date) : formatDate(item.date)),
                            y: .value("Value", item.value)
                        )
                    }
                    .foregroundStyle(by: .value("Variable", series.variable))
                }
            }
        }

        func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM"
            return formatter.string(from: date)
        }

        func formatTime(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            return formatter.string(from: date)
        }
    }
}
