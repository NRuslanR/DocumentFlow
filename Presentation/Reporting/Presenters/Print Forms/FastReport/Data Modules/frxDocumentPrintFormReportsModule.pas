unit frxDocumentPrintFormReportsModule;

interface

uses
  SysUtils, Classes, frxClass, frxDBSet, DB, dxmdaset, frxExportXLS,
  frxExportPDF, frxExportRTF, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  DBClient;

type
  TfrxDocumentPrintFormReports = class(TDataModule)
    ServiceNotePrintFormReport: TfrxReport;
    ServiceNoteContentReportDataSet: TfrxDBDataset;
    ServiceNoteContentDataSource: TDataSource;
    ContentDataSet: TdxMemData;
    ContentDataSetcontent: TStringField;
    DocumentPrintFormPDFExport: TfrxPDFExport;
    DocumentPrintFormRTFExport: TfrxRTFExport;
    frxDocumentApprovingListRecordSet: TfrxDBDataset;
    DocumentApprovingListRecordSource: TDataSource;
    frxDocumentApprovingListSet: TfrxDBDataset;
    DocumentApprovingListSource: TDataSource;
    DocumentApprovingListSet: TClientDataSet;
    DocumentApprovingListRecordSet: TClientDataSet;
    DocumentApprovingListSettitle: TStringField;
    DocumentApprovingListRecordSettitle: TStringField;
    DocumentApprovingListRecordSetapprover_name: TStringField;
    DocumentApprovingListRecordSetapprover_speciality: TStringField;
    DocumentApprovingListRecordSetapproving_result_name: TStringField;
  private

  public

    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
    
  end;

implementation

uses

  AuxDataSetFunctionsUnit;

{$R *.dfm}

{ TfrxDocumentPrintFormReports }

constructor TfrxDocumentPrintFormReports.Create(AOwner: TComponent);
begin

  inherited;

  ContentDataSet.Active := True;
  
  ContentDataSet.Append;
  ContentDataSet.Post;

end;

destructor TfrxDocumentPrintFormReports.Destroy;
begin

  inherited;
  
end;

end.
