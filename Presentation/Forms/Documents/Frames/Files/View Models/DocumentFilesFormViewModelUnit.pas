unit DocumentFilesFormViewModelUnit;

interface

uses

  SysUtils,
  Classes,
  DocumentFileSetHolder,
  DB;

type

  TDocumentFilesFormViewModel = class

    protected

      { � ������� �������� ����
        �������� ������������ ��������
        ��� ���������� ����������� }
        
      FDocumentFileSetHolder: TDocumentFileSetHolder;

      procedure SetDocumentFileSetHolder(
        DocumentFileSetHolder: TDocumentFileSetHolder
      );

      function GetDocumentFileSetHolder:
        TDocumentFileSetHolder;

    public

      destructor Destroy; override;

      property DocumentFileSetHolder:
        TDocumentFileSetHolder
      read GetDocumentFileSetHolder
      write SetDocumentFileSetHolder;
      
  end;

  TDocumentFilesPageViewModelClass = class of TDocumentFilesFormViewModel;

implementation

{ TDocumentFilesFormViewModel }

destructor TDocumentFilesFormViewModel.Destroy;
begin

  FreeAndNil(FDocumentFileSetHolder);
  inherited;

end;

function TDocumentFilesFormViewModel.GetDocumentFileSetHolder:
  TDocumentFileSetHolder;
begin

  Result := FDocumentFileSetHolder;

end;

procedure TDocumentFilesFormViewModel.SetDocumentFileSetHolder(
  DocumentFileSetHolder: TDocumentFileSetHolder
);
begin

  if DocumentFileSetHolder <> FDocumentFileSetHolder
  then FreeAndNil(FDocumentFileSetHolder);

  FDocumentFileSetHolder := DocumentFileSetHolder;
  
end;

end.
