unit frxNotPerformedDocumentsReportObjectsUnit;

interface

uses
  SysUtils, Classes, DB, frxClass, frxDBSet, dxmdaset, frxExportRTF,
  frxExportPDF, frxDesgn;

type
  TfrxNotPerformedDocumentsReportObjects = class(TDataModule)
    NotPerformedDocumentsReport: TfrxReport;
    NotPerformedDocumentsReportDataSet: TfrxDBDataset;
    NotPerformedDocumentsDataSource: TDataSource;
    NotPerformedDocumentsReportPDFExport: TfrxPDFExport;
    NotPerformedDocumentsReportRTFExport: TfrxRTFExport;
  private

  public

  end;

var
  frxNotPerformedDocumentsReportObjects: TfrxNotPerformedDocumentsReportObjects;

implementation

{$R *.dfm}

end.
