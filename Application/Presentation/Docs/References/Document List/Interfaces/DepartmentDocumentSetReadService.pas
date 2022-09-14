unit DepartmentDocumentSetReadService;

interface

uses

  ApplicationService,
  DocumentSetHolder,
  VariantListUnit,
  SysUtils;

type

  IDepartmentDocumentSetReadService = interface (IApplicationService)
    ['{AC26D9FA-BF1E-402B-8FDC-6DCB6701D6CA}']
    
    function GetPreparedDocumentSet(const DepartmentIds: TVariantList): TDocumentSetHolder;
    function GetPreparedDocumentSetByIds(const DocumentIds: TVariantList): TDocumentSetHolder; overload;
    function GetPreparedDocumentSetByIds(const DocumentIds: array of Variant): TDocumentSetHolder; overload;

  end;

implementation

end.
