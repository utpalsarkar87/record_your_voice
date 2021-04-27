//
//  RecordYourVoiceTests.swift
//  RecordYourVoiceTests
//
//

import XCTest
@testable import RecordYourVoice

class RecordYourVoiceTests: XCTestCase {
    
    var yourVoiceListVC: YourVoiceListViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        yourVoiceListVC = YourVoiceListViewController.create()
        _ = yourVoiceListVC.view
        yourVoiceListVC.viewDidLoad()
        yourVoiceListVC.viewWillAppear(true)
        yourVoiceListVC.viewDidAppear(true)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        yourVoiceListVC = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testRecorderViewControllerCreation() throws {
        let viewModel = YourVoiceListViewModel()
        let recordView = viewModel.getIQAudioRecorderViewController()
        XCTAssertNotNil(recordView, "Found Nil")
        XCTAssertEqual(recordView.maximumRecordDuration, viewModel.MAX_RECORD_DURATION)
        XCTAssertEqual(recordView.allowCropping, false)
        XCTAssertEqual(recordView.barStyle, .default)
    }

    func testAudioListsControllerCreation() throws {
        let viewModel = YourVoiceListViewModel()
        let audioView = viewModel.getAudioRecordList(fileName: "FileName",
                                                     filePath: "FilePath",
                                                     recentlyDeleted: false,
                                                     dateTime: Date(),
                                                     fileLength: 0,
                                                     dateCreated: "")
        XCTAssertEqual(audioView.fileName, "FileName")
        XCTAssertEqual(audioView.filePath, "FilePath")
        XCTAssertEqual(audioView.recentlyDeleted, false)
        XCTAssertEqual(audioView.fileLength, 0)
        XCTAssertEqual(audioView.dateCreated, "")
    }
}
