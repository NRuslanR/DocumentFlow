unit EmployeeDocumentCardFormViewModelMapper;

interface

uses

  DocumentCardFormViewModel,
  EmployeeDocumentCardFormViewModel,
  DocumentCardFormViewModelMapper,
  SysUtils,
  Classes;

type

  TEmployeeDocumentCardFormViewModelMapper = class (TDocumentCardFormViewModelMapper)

    protected

      function CreateDocumentCardFormViewModelInstance:
        TDocumentCardFormViewModel; override;
        
  end;

implementation

{ TEmployeeDocumentCardFormViewModelMapper }

function TEmployeeDocumentCardFormViewModelMapper.CreateDocumentCardFormViewModelInstance: TDocumentCardFormViewModel;
begin

  Result := TEmployeeDocumentCardFormViewModel.Create;

end;

end.
