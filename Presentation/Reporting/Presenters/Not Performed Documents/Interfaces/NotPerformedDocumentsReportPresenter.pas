unit NotPerformedDocumentsReportPresenter;

interface

uses

  NotPerformedDocumentsReportData,
  SysUtils;

type

  TNotPerformedDocumentsReportPresenterException = class (Exception)

  end;
  
  INotPerformedDocumentsReportPresenter = interface

    procedure PresentReportBy(
      NotPerformedDocumentsReportData: TNotPerformedDocumentsReportData
    );
    
  end;
  
implementation

end.
