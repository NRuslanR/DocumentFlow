unit unFastReportApprovingSheetDataModule;

interface

uses
  SysUtils, Classes, frxClass, DB, frxDBSet;

type
  TFastReportApprovingSheetDataModule = class(TDataModule)
    ApprovingSheetReport: TfrxReport;
    ApprovingSet: TfrxDBDataset;
    ApprovingSetDataSource: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
