/* This file was generated by upb_generator from the input file:
 *
 *     envoy/extensions/filters/http/router/v3/router.proto
 *
 * Do not edit -- your changes will be discarded when the file is
 * regenerated. */

#include <stddef.h>
#include "upb/generated_code_support.h"
#include "envoy/extensions/filters/http/router/v3/router.upb_minitable.h"
#include "envoy/config/accesslog/v3/accesslog.upb_minitable.h"
#include "envoy/extensions/filters/network/http_connection_manager/v3/http_connection_manager.upb_minitable.h"
#include "google/protobuf/duration.upb_minitable.h"
#include "google/protobuf/wrappers.upb_minitable.h"
#include "envoy/annotations/deprecation.upb_minitable.h"
#include "udpa/annotations/status.upb_minitable.h"
#include "udpa/annotations/versioning.upb_minitable.h"
#include "validate/validate.upb_minitable.h"

// Must be last.
#include "upb/port/def.inc"

static const upb_MiniTableSub envoy_extensions_filters_http_router_v3_Router_submsgs[4] = {
  {.submsg = &google__protobuf__BoolValue_msg_init},
  {.submsg = &envoy__config__accesslog__v3__AccessLog_msg_init},
  {.submsg = &envoy__extensions__filters__network__http_0connection_0manager__v3__HttpFilter_msg_init},
  {.submsg = &envoy__extensions__filters__http__router__v3__Router__UpstreamAccessLogOptions_msg_init},
};

static const upb_MiniTableField envoy_extensions_filters_http_router_v3_Router__fields[9] = {
  {1, UPB_SIZE(4, 8), 1, 0, 11, (int)kUpb_FieldMode_Scalar | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)},
  {2, UPB_SIZE(8, 1), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)},
  {3, UPB_SIZE(12, 16), 0, 1, 11, (int)kUpb_FieldMode_Array | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)},
  {4, UPB_SIZE(16, 2), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)},
  {5, UPB_SIZE(20, 24), 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Array | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)},
  {6, UPB_SIZE(24, 3), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)},
  {7, UPB_SIZE(25, 4), 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)},
  {8, UPB_SIZE(28, 32), 0, 2, 11, (int)kUpb_FieldMode_Array | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)},
  {9, UPB_SIZE(32, 40), 2, 3, 11, (int)kUpb_FieldMode_Scalar | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)},
};

const upb_MiniTable envoy__extensions__filters__http__router__v3__Router_msg_init = {
  &envoy_extensions_filters_http_router_v3_Router_submsgs[0],
  &envoy_extensions_filters_http_router_v3_Router__fields[0],
  UPB_SIZE(40, 48), 9, kUpb_ExtMode_NonExtendable, 9, UPB_FASTTABLE_MASK(120), 0,
  UPB_FASTTABLE_INIT({
    {0x0000000000000000, &_upb_FastDecoder_DecodeGeneric},
    {0x000800000100000a, &upb_psm_1bt_maxmaxb},
    {0x000100003f000010, &upb_psb1_1bt},
    {0x001000003f01001a, &upb_prm_1bt_maxmaxb},
    {0x000200003f000020, &upb_psb1_1bt},
    {0x001800003f00002a, &upb_prs_1bt},
    {0x000300003f000030, &upb_psb1_1bt},
    {0x000400003f000038, &upb_psb1_1bt},
    {0x002000003f020042, &upb_prm_1bt_maxmaxb},
    {0x002800000203004a, &upb_psm_1bt_max64b},
    {0x0000000000000000, &_upb_FastDecoder_DecodeGeneric},
    {0x0000000000000000, &_upb_FastDecoder_DecodeGeneric},
    {0x0000000000000000, &_upb_FastDecoder_DecodeGeneric},
    {0x0000000000000000, &_upb_FastDecoder_DecodeGeneric},
    {0x0000000000000000, &_upb_FastDecoder_DecodeGeneric},
    {0x0000000000000000, &_upb_FastDecoder_DecodeGeneric},
  })
};

static const upb_MiniTableSub envoy_extensions_filters_http_router_v3_Router_UpstreamAccessLogOptions_submsgs[1] = {
  {.submsg = &google__protobuf__Duration_msg_init},
};

static const upb_MiniTableField envoy_extensions_filters_http_router_v3_Router_UpstreamAccessLogOptions__fields[2] = {
  {1, 1, 0, kUpb_NoSub, 8, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_1Byte << kUpb_FieldRep_Shift)},
  {2, UPB_SIZE(4, 8), 1, 0, 11, (int)kUpb_FieldMode_Scalar | ((int)UPB_SIZE(kUpb_FieldRep_4Byte, kUpb_FieldRep_8Byte) << kUpb_FieldRep_Shift)},
};

const upb_MiniTable envoy__extensions__filters__http__router__v3__Router__UpstreamAccessLogOptions_msg_init = {
  &envoy_extensions_filters_http_router_v3_Router_UpstreamAccessLogOptions_submsgs[0],
  &envoy_extensions_filters_http_router_v3_Router_UpstreamAccessLogOptions__fields[0],
  UPB_SIZE(8, 16), 2, kUpb_ExtMode_NonExtendable, 2, UPB_FASTTABLE_MASK(24), 0,
  UPB_FASTTABLE_INIT({
    {0x0000000000000000, &_upb_FastDecoder_DecodeGeneric},
    {0x000100003f000008, &upb_psb1_1bt},
    {0x0008000001000012, &upb_psm_1bt_maxmaxb},
    {0x0000000000000000, &_upb_FastDecoder_DecodeGeneric},
  })
};

static const upb_MiniTable *messages_layout[2] = {
  &envoy__extensions__filters__http__router__v3__Router_msg_init,
  &envoy__extensions__filters__http__router__v3__Router__UpstreamAccessLogOptions_msg_init,
};

const upb_MiniTableFile envoy_extensions_filters_http_router_v3_router_proto_upb_file_layout = {
  messages_layout,
  NULL,
  NULL,
  2,
  0,
  0,
};

#include "upb/port/undef.inc"
