unit DocumentFilesViewFormViewModel;

interface

uses

  DocumentFileInfoList,
  SysUtils,
  Classes;

type

  TDocumentFilesViewFormViewModel = class

    private

      FDocumentFileInfoList: TDocumentFileInfoList;

    public

      destructor Destroy; override;

      constructor Create; overload;
      constructor Create(DocumentFileInfoList: TDocumentFileInfoList); overload;

    published

      property DocumentFileInfoList: TDocumentFileInfoList
      read FDocumentFileInfoList write FDocumentFileInfoList;
      
  end;
  
implementation

{ TDocumentFilesViewFormViewModel }

constructor TDocumentFilesViewFormViewModel.Create(
  DocumentFileInfoList: TDocumentFileInfoList);
begin

  inherited Create;

  FDocumentFileInfoList := DocumentFileInfoList;
  
end;

constructor TDocumentFilesViewFormViewModel.Create;
begin

  inherited;
  
end;

destructor TDocumentFilesViewFormViewModel.Destroy;
begin

  //FreeAndNil(FDocumentFileInfoList);
  inherited;

end;

end.
